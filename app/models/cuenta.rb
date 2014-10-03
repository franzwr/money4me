class Cuenta < RemoteBase
	self.table_name = "Cuenta"
	self.primary_key = "id_cuenta"
	belongs_to :empresa, foreign_key: "id_cuenta"
	has_many :detalles, foreign_key: "id_cuenta"
	has_many :pagos, through: :detalles 

  validate :id_propio_empresa, presence: true, uniqueness: true
  validate :monto,             presence: true
  validate :rut_cliente,       presence: true

  validate :fecha_limite_after_fecha_registro
  def fecha_limite_after_fecha_registro
    errors.add(:fecha_limite, "must sucede fecha_registro") unless fecha_limite >= fecha_registro
  end

  def impagas
    # http://stackoverflow.com/a/23389130/3741258
    where.not(id_cuenta: Pago.select(:id_cuenta).uniq)
  end

  def pagadas
    # http://stackoverflow.com/a/23389130/3741258
    where(id_cuenta: Pago.select(:id_cuenta).uniq)
  end

  def cercanas_a_vencer
    # Will this work? Date difference
    impagas.where("fecha_limite - ? <= ?", Date.today, 2.days)
  end
end
