class Rubro < RemoteBase
	self.table_name = "Rubro"
	self.primary_key = "id_rubro"
	has_many :empresarubros, foreign_key: "id_rubro"
	has_many :empresas, through: :empresarubros
end
