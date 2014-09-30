class Detalle < RemoteBase
	self.table_name = "Detalle"
	belongs_to :cuenta, foreign_key: "id_cuenta"
	belongs_to :pago, foreign_key: "id_pago"
end