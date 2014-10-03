class Cuenta < RemoteBase
	self.table_name = "Cuenta"
	self.primary_key = "id_cuenta"
	belongs_to :empresa, foreign_key: "id_cuenta"
	has_many :detalles, foreign_key: "id_cuenta"
	has_many :pagos, through: :detalles 

  def impagas
    # http://stackoverflow.com/a/23389130/3741258
    where.not(id_cuenta: Pago.select(:id_cuenta).uniq)
  end

  def pagadas
    # http://stackoverflow.com/a/23389130/3741258
    where(id_cuenta: Pago.select(:id_cuenta).uniq)
  end
end
