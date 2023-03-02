class User < ApplicationRecord
  has_many :seats, dependent: :destroy
  has_many :cinemas, dependent: :destroy
  has_many :movies, dependent: :destroy

  before_save { email.downcase! }

  validates :full_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true
  validates :number, presence: true
  validates :password, presence: true

  enum role: {
    customer: 0,
    admin: 1
  }

  has_secure_password

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
