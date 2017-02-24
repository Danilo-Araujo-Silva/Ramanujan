class Contact < ApplicationRecord
  validates :name, :email, :state, :role, presence: { message: "não pode estar vazio." }, allow_blank: false
  validates_email_format_of :email, { message: 'inválido.' }
  validates :email, uniqueness: { message: "já foi cadastrado. Por favor escolha outro e-mail." }
  validates :age, numericality: { :greater_than => 0, :less_than_or_equal_to => 150, message: "%{value} deveria ser um valor inteiro maior que zero e menor que 150." }  
end
