# = detalle.rb
#
# Details (Detalle) class, inherits from RemoteBase. Abstractions of the 'Detalle' table from the external database.
# All relationships and validations are defined here.
class Detalle < RemoteBase
	# Table properties mapped to ActiveRecord
	self.table_name = "Detalle"

	# Many to many reationship decomposition between Payment (Pago) and Bill (Cuenta).
	belongs_to :cuenta, foreign_key: "id_cuenta"
	belongs_to :pago, foreign_key: "id_pago"
end