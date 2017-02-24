class Segmentation < ApplicationRecord
  validates :title, presence: { message: "não pode estar vazio." }, allow_blank: false
  validates :description, presence: { message: "não pode estar vazia." }
  validate :validate_query_and_parameters

  def validate_query_and_parameters
    errors.add(:base, @@invalid_query_parameters_message) unless Segmentation.is_validate_query_and_parameters(query, parameters)
  end

  class << self
    @@invalid_query_parameters_message = "Critérios inválidos. Os critérios não puderam ser processados corretamente. Verifique se os mesmos estão corretos e tente novamente."

    def is_validate_query_and_parameters(query, parameters)
      return false unless is_valid_query(query)
      return false unless is_valid_parameters(parameters)

      if !query.nil? and !parameters.nil?
        begin
          where = Segmentation.build_where(
            JSON.parse(query),
            JSON.parse(parameters)
          )

          return false unless is_valid_where(where)
        rescue Exception
          return false
        end
      end

      true
    end

    def is_valid_query(query)
      if query.nil?
        return true
      elsif query.empty?
        return false
      else
        begin
          JSON.parse(query)

          return true
        rescue Exception
          return false
        end
      end
    end

    def is_valid_parameters(parameters)
      if parameters.nil?
        return true
      elsif parameters.empty?
        return false
      else
        begin
          JSON.parse(parameters)

          return true
        rescue Exception
          return false
        end
      end
    end

    def is_valid_where(where)
      begin
        Contact.where(:id => -1).where(where).inspect

        return true
      rescue Exception
        return false
      end
    end

    def build_where(raw_query, parameters)
      raw_query.compact!
      parameters.compact!
      sanitized = ActiveRecord::Base.send(
        :sanitize_sql_array,
        [raw_query.join(" ").gsub(/\#\{[0-9]+\}/, "")] + parameters.map(&:join)
      )

      eval %Q{"#{sanitized}"}
    end

    def build_from_query_and_parameters(raw_query_array, parameters_array)
      raw_query_array.compact!
      parameters_array.compact!
      result = []
      all_operators_keys = @@dictionary[:operators][:all].keys

      raw_query_array.each_with_index do |query, block|
        parameters_count = 0
        block = block.to_i
        result[block] = []
        position = 0

        query.split.each_with_index do |part, index|
          position = index
          result[block][position] = {}
          if all_operators_keys.include?(part)
            operator = @@dictionary[:operators][:all][:"#{part}"]
            result[block][position]["operator"] = {}
            result[block][position]["operator"][operator[:type]] = operator[:id]
          elsif part == "LIKE"
            result[block][position]["operator"] = {}
            result[block][position]["operator"]["textual"] = {}
            if parameters_array[block][parameters_count] =~ /^%.*%$/
              result[block][position]["operator"]["textual"] = "^%.*%$"
            elsif parameters_array[block][parameters_count] =~ /^%.*$/
              result[block][position]["operator"]["textual"] = "^%.*$"
            elsif parameters_array[block][parameters_count] =~ /^.*%$/
              result[block][position]["operator"]["textual"] = "^.*%$"
            else
              result[block][position]["operator"]["textual"] = "^.*$"
            end
          elsif part == "?"
            result[block][position]["placeholder"] = {}
            field_array = result[block][position -2]["field"]
            placeholder = parameters_array[block][parameters_count].gsub(/%/, "")
            if field_array.key?("textual")
              result[block][position]["placeholder"]["textual"] = placeholder
            elsif field_array.key?("numeric")
              result[block][position]["placeholder"]["numeric"] = placeholder
            else
              throw "A posição anterior a anterior do placeholder é desconhecida (#{result[block][position - 2].keys})."
            end

            parameters_count += 1
          elsif part =~ /\#\{:[a-z]+\}.*/
            key = part.gsub(/\W/, "")
            field = @@dictionary[:tables][:contact][:fields][:"#{key}"]
            result[block][position]["field"] = {}
            result[block][position]["field"][field[:type]] = field[:id]
          elsif part =~ /\#\{[0-9]+\}.*/
            key = part.gsub(/\D/, "")
            key = key.to_i
            if [0, 1, 5, 6].include?(key)
              result[block][position]["operator"] = {}

              if [0, 6].include?(key)
                result[block][position]["operator"]["aggregation"] = ""
              elsif [1, 5].include?(key)
                result[block][position]["operator"]["logical"] = ""
              else
                throw "Índice não encontrado (#{key})."
              end
            else
              throw "Índice desconhecido (#{key})."
            end
          else
            throw "Foi encontrada uma parte desconhecida para compor a query (#{part})."
          end
        end
      end

      result
    end

    def parse_from_raw_parameters(raw_parameters)
      raw_parameters.compact!
      query = []
      parameters = []
      last = nil

      raw_parameters.each do |block, block_array|
        block = block.to_i
        query[block] = ""
        parameters[block] = []

        block_array.each do |position, parameter_array|
          parameter_array.each do |type, type_array|
            type_array.each do |sub_type, value|
              value.strip!
              if value.empty?
                query[block] += "\#{#{position}} "
              else
                if type == "field"
                  if @@dictionary[:tables][:contact][:fields].key?(value)
                    query[block] += "\#{:#{value}} "
                  else
                    throw "Campo desconhecido para a tabela de contatos (#{value})."
                  end
                elsif type == "placeholder"
                  prefix = ""
                  sufix = ""

                  if sub_type == "textual"
                    if last.nil?
                      throw "O último critério é inválido e o sistema esperava que este não fosse."
                    end
                    if (last[:id] == "^%.*$")
                      prefix = "%"
                    elsif (last[:id] == "^%.*%$")
                      prefix = "%"
                      sufix = "%"
                    elsif (last[:id] == "^.*$")
                    elsif (last[:id] == "^.*%$")
                      sufix = "%"
                    else
                      throw "O último critério é desconhecido (#{last})."
                    end

                    last = nil
                  elsif sub_type == "numeric"
                  else
                    throw "Tipo de placeholder desconhecido (#{sub_type})."
                  end

                  query[block] += "? "
                  parameters[block].push(prefix + value + sufix)
                else
                  if sub_type == "aggregation"
                    if @@dictionary[:operators][:aggregation].key?(value)
                      query[block] += "#{value} "
                    else
                      throw "Parâmetro de agregação desconhecido (#{value})."
                    end
                  elsif sub_type == "logical"
                    if @@dictionary[:operators][:logical].key?(value)
                      query[block] += "#{value} "
                    else
                      throw "Parâmetro lógico desconhecido (#{value})."
                    end
                  elsif sub_type == "numeric"
                    if @@dictionary[:operators][:numeric].key?(value)
                      query[block] += "#{value} "
                    else
                      throw "Parâmetro numérico desconhecido (#{value})."
                    end
                  elsif sub_type == "textual"
                    if @@dictionary[:operators][:textual].key?(value)
                      last = @@dictionary[:operators][:textual][value]
                      query[block] += "LIKE "
                    else
                      throw "Parâmetro textual desconhecido (#{value})."
                    end
                  else
                    throw "Tipo inesperado."
                  end
                end
              end
            end
          end
        end
      end

      {"query": query, "parameters": parameters}
    end

    def create_dictionary
      dictionary = {
        "operators": {
          "logical": {
            "and": {"id": "and", "name": "e", "type": "logical"},
            "or": {"id": "or", "name": "ou", "type": "logical"},
          },
          "aggregation": {
            "(": {"id": "(", "name": "(", "type": "aggregation"},
            ")": {"id": ")", "name": ")", "type": "aggregation"},
          },
          "numeric": {
            "<": {"id": "<", "name": "menor que", "type": "numeric"},
            "<=": {"id": "<=", "name": "menor ou igual a", "type": "numeric"},
            "=": {"id": "=", "name": "igual a", "type": "numeric"},
            ">=": {"id": ">=", "name": "maior ou igual a", "type": "numeric"},
            ">": {"id": ">", "name": "maior que", "type": "numeric"},
          },
          "textual": {
            "^%.*%$": {"id": "^%.*%$", "name": "contém", "type": "textual"},
            "^.*%$": {"id": "^.*%$", "name": "começa com", "type": "textual"},
            "^%.*$": {"id": "^%.*$", "name": "termina com", "type": "textual"},
            "^.*$": {"id": "^.*$", "name": "igual a", "type": "textual"}
          }
        },
        "tables": {
          "contact": {
            "fields": {
              "name": {
                "id": "name",
                "name": "nome",
                "type": "textual"
              },
              "email": {
                "id": "email",
                "name": "e-mail",
                "type": "textual"
              },
              "age": {
                "id": "age",
                "name": "idade",
                "type": "numeric"
              },
              "state": {
                "id": "state",
                "name": "estado",
                "type": "textual"
              },
              "role": {
                "id": "role",
                "name": "cargo",
                "type": "textual"
              },
            }
          }
        }
      }.with_indifferent_access

      dictionary[:operators][:all] = {}

      dictionary[:operators].each do |index, array|
        array.each do |id, operator|
          dictionary[:operators][:all][id] = operator
        end
      end

      dictionary
    end

    @@dictionary = Segmentation.create_dictionary

    def dictionary
      @@dictionary
    end
  end
end
