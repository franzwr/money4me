# = user.rb
#
# Base class for all users. Defines devise modules.
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Model validations. Self-explained
  validates :email, presence: true, uniqueness: true

end
