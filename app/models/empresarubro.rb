class Empresarubro < RemoteBase
	self.table_name = "Empresa_Rubro"
	belongs_to :rubro, foreign_key: "id_rubro"
	belongs_to :empresa, foreign_key: "id_empresa"
end