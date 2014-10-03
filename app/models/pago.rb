class Pago < RemoteBase
	self.table_name = "Pago"
	self.primary_key = "id_pago"
	has_many :detalles, foreign_key: "id_pago"
	has_many :cuentas, through: :detalles

  validates :cuentas, presence: true, allow_blank: true

  validates :cuenta_banco, presence: true
  validates :rut_cliente,  presence: true
  validates :email,        presence: true

  validates_each :cuenta do |record, attr, value|
    # (In controller) Don't allow for paying a receipt more than once
    # Don't allow for paying someone else's receipts
    record.errors.add(attr, "pertenece a otro RUT") if value.rut_cliente != rut_cliente
  end
  
end
