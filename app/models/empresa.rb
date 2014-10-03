class Empresa < RemoteBase
	self.table_name = "Empresa"
	self.primary_key = "id_empresa"
	has_many :empresarubros, foreign_key: "id_empresa"
	has_many :rubros, through: :empresarubros
	has_many :cuentas, foreign_key: "id_empresa"

  validates :rubros, presence: true, allow_blank: true
end
