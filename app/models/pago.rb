class Pago < RemoteBase
	self.table_name = "Pago"
	self.primary_key = "id_pago"
	has_many :detalles, foreign_key: "id_pago"
	has_many :cuentas, through: :detalles
end