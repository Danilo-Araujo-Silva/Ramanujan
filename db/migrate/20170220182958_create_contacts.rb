class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      # Foram criados índices para quase todas as colunas para que as queries pudessem ficar mais performáticas,
      #   no entanto, para um software mais robusto a inclusão de índices deveria ser analisada com mais
      #   cautela.
      # Todos os campos dos contatos foram também assumidos como sendo obrigatórios.
      # As validações de tamanho (limit) foram delegadas para outras classes.
      t.string :name, null: false, index: true, comment: 'Nome do contato.'
      t.string :email, null: false, index: true, comment: 'E-mail do contato.'
      t.integer :age, null: false, index: true, comment: 'Idade atual do contato.'
      t.string :state, null: false, index: true, comment: 'Estado do Brasil aonde o contato vive.'
      t.string :role, null: false, index: true, comment: 'Cargo/função exercida pelo contato.'

      t.timestamps
    end
  end
end
