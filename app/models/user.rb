class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true, email: true
  validates :password, password_strength: false, length: { minimum: 8 }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end