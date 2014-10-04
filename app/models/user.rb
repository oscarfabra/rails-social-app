class User < ActiveRecord::Base

  # Attributes additional to the database model
  attr_accessor :remember_token

  # User validations
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

  # Class method that returns a random token for remembering a user's session
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    remember_digest = User.digest(remember_token)
    update_attribute(:remember_digest, remember_digest)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    password = BCrypt::Password.new(remember_digest)
    password.is_password?(remember_token)
  end
end
