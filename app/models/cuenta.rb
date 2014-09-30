class Cuenta < RemoteBase
	self.table_name = "Cuenta"
	self.primary_key = "id_cuenta"
	belongs_to :empresa, foreign_key: "id_cuenta"
	has_many :detalles, foreign_key: "id_cuenta"
	has_many :pagos, through: :detalles 
end