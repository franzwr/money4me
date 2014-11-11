class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable

  belongs_to :empresa

  validates :rut, uniqueness: true

  # how to do has_many over non-primary key?
  def cuentas
    Cuenta.where("rut_cliente == ?", rut)
  end
end
