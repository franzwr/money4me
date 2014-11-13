# = rubro.rb
#
# Entry (Rubro) class, inherits from RemoteBase. Abstraction of the 'rubros' table from the external database.
# All relationships and validations are defined here.
class Rubro < RemoteBase

	# Table properties mapped to ActiveRecords.
	self.table_name = "Rubro"
	self.primary_key = "id_rubro"

	# Many to many relationship with Entry (Rubro).
	has_many :empresarubros, foreign_key: "id_rubro"
	has_many :empresas, through: :empresarubros
end
