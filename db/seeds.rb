# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Default admin user seed.

Admin.create({:name => "Root Admin", :email => "admin@money4me.cl", :password => "admin1234",
 :password_confirmation => "admin1234", :rut => "123456785"})

CompanyUser.create( 	
  rut: "697262024", 	
  name: "Victor", 	
  id_empresa: 1, # VTR 	
  email: "victor@vtr.cl", 	
  password: "asdfasdf", 	
) 	
 	
Client.create( 	
  rut: "868524305", 	
  name: "Hola", 	
  email: "usuario@money4me.cl", 	
  password: "asdfasdf", 	
)
