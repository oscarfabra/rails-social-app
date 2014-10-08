class User < ActiveRecord::Base

  # Attributes additional to the database model
  attr_accessor :remember_token, :activation_token, :reset_token

  # User validations
  before_save   :downcase_email
  before_create :create_activation_digest
  validates     :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX }, 
  uniqueness: { case_sensitive: false }
  has_secure_password
  validates           :password, length: { minimum: 8 }, allow_blank: true

  # Class methods
  class << self
    # Returns the hash digest of the given string
    def digest(string)
      # Uses the minimum cost parameter in tests and a normal (high) cost param
      # in production
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
      BCrypt::Engine.cost
      BCrypt::Password.create(string, cost: cost)
    end

    # Returns a random token for remembering a user's session
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    remember_digest = User.digest(remember_token)
    update_attribute(:remember_digest, remember_digest)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates a user account.
  def activate
    update_attribute(:activated, true)
    update_attribute(:activated_at, Time.zone.now)    
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_attribute(:reset_digest, User.digest(reset_token))
    update_attribute(:reset_sent_at, Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 24.hours.ago    
  end

  # Private methods
  private

    # Converts email to all lower-case.
    def downcase_email
      self.email.downcase!      
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(self.activation_token)
    end
end
