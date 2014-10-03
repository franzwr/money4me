class Usuario < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  validates :rut, uniqueness: true

  # how to do has_many over non-primary key?
  def cuentas
    Cuenta.where("rut_cliente == ?", rut)
  end
end
