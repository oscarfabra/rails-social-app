class User < ActiveRecord::Base
  before_save { self.email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX }, 
  uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 8 }

  # Class method that returns the hash digest of the given string
  def User.digest(string)
    # Uses the minimum cost parameter in tests and a normal (high) cost param
    # in production
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
