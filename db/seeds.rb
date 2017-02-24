# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

contacts = Contact.create([
  {
    name: 'Danilo Araújo Silva',
    email: 'silva.danilo.araujo@gmail.com',
    age: 29,
    state: 'SC',
    role: 'Analista de TI'
  },
  {
    name: 'Gabriela Rocha Silva',
    email: 'gabrielaroc@yahoo.com.br',
    age: 59,
    state: 'PR',
    role: 'Diretora Comercial'
  },
  {
    name: 'Lara Santos Barros',
    email: 'larasant87@gmail.com',
    age: 29,
    state: 'SP',
    role: 'UX Designer'
  },
  {
    name: 'Nicolas Araujo Rocha',
    email: 'nicolasroc38@uol.com',
    age: 26,
    state: 'SE',
    role: 'Redator'
  },
  {
    name: 'Leonardo Oliveira Gomes',
    email: 'leonardo83@gmail.com',
    age: 54,
    state: 'RJ',
    role: 'Desenvolvedor de Software'
  },
  {
    name: 'Kauan Melo Rocha',
    email: 'kauanmelo123@yahoo.com.br',
    age: 49,
    state: 'PE',
    role: 'Diretor de Marketing'
  },
  {
    name: 'Maria Dias Fernandes',
    email: 'mariafernandes55@bol.com.br',
    age: 33,
    state: 'SC',
    role: 'Analista de Recursos Humanos'
  },
  {
    name: 'Luiza Castro Costa',
    email: 'luizaccosta@msn.com',
    age: 40,
    state: 'DF',
    role: 'Produtora Musical'
  },
  {
    name: 'Livia Carvalho Alves',
    email: 'liviaalves112@gmail.com',
    age: 31,
    state: 'SC',
    role: 'Analista de Inovação'
  },
  {
    name: 'Luiz Melo Cunha',
    email: 'luizmelocunha17@gmail.com',
    age: 39,
    state: 'SP',
    role: 'Engenheiro de Produção'
  },
  {
    name: 'Thaís Ribeiro Cardoso',
    email: 'thaisribeiro13@yahoo.com.br',
    age: 32,
    state: 'RJ',
    role: 'Diretora de Marketing'
  }
])

segmentations = Segmentation.create([
  {
    title: 'Residentes em SC Maiores de 30 Anos',
    description: 'Segmentação dos contatos que residem no estado de Santa Catarina, Brasil e que possuem idade maior que 30 anos.',
    query: '["\#{0} \#{1} \#{:state} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:age} > ? \#{5} \#{6} "]',
    parameters: '[["SC"], ["30"]]'
  },
  {
    title: 'Diretores de Marketing ou Residentes em São Paulo',
    description: 'Segmentação dos contatos que têm o cargo de Diretor de Marketing ou que residam no estado de São Paulo, Brasil.',
    query: '["( \#{1} \#{:role} LIKE ? and \#{6} ", "\#{0} \#{1} \#{:role} LIKE ? \#{5} ) ", "\#{0} or \#{:state} LIKE ? \#{5} \#{6} "]',
    parameters: '[["%Diretor%"], ["%Marketing%"], ["SP"]]'
  }
])