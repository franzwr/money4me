# = empresarubro.rb
#
# EmpresaRubro class, inherits from RemoteBase. Abstraction of the 'Empresa_Rubro' table from the external database.
# All relationships and validations are defined here.
class Empresarubro < RemoteBase
	# Table properties mapped to ActiveRecord
	self.table_name = "Empresa_Rubro"

	# Many to many relationship decomposition between Entry (Rubro) and Company (Empresa).
	belongs_to :rubro, foreign_key: "id_rubro"
	belongs_to :empresa, foreign_key: "id_empresa"
end