class User < ActiveRecord::Base

  #----------------------------------------------------------------------------
  # Associations
  #----------------------------------------------------------------------------

  # Has many microposts
  has_many :microposts, dependent: :destroy
  # Has many active relationships (followings)
  has_many :active_relationships, class_name: "Relationship", 
  foreign_key: "follower_id", dependent: :destroy
  # Has many followings (followeds) through the active_relationship followeds
  has_many :following, through: :active_relationships, source: :followed
  # Has many passive relationships (followers)
  has_many :passive_relationships, class_name: "Relationship", 
  foreign_key: "followed_id", dependent: :destroy
  # Has many followers through the passive_relationship followers
  has_many :followers, through: :passive_relationships, source: :follower

  #----------------------------------------------------------------------------
  # Attributes (additional to the database model)
  #----------------------------------------------------------------------------

  # tokens accessors
  attr_accessor :remember_token, :activation_token, :reset_token

  #----------------------------------------------------------------------------
  # Validations
  #----------------------------------------------------------------------------

  # Down-cases email before saving it in the db
  before_save   :downcase_email
  # Creates activation digest before creating the user
  before_create :create_activation_digest
  # Requires name before create action
  validates     :name, presence: true, length: { maximum: 50 }
  # Email should be present and match the given regex
  VALID_EMAIL_REGEX =  /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates     :email, presence: true, 
    format: {with: VALID_EMAIL_REGEX }, 
    uniqueness: { case_sensitive: false }
  # Password should be secure
  has_secure_password
  # Password length should be at least 8, blanks allowed (for testing)
  validates     :password, length: { minimum: 8 }, allow_blank: true

  #----------------------------------------------------------------------------
  # Class methods
  #----------------------------------------------------------------------------

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

  #----------------------------------------------------------------------------
  # Public methods
  #----------------------------------------------------------------------------

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
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), 
      reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 24.hours.ago    
  end

  # Returns the feed of microposts for this user.
  def feed
    # This is preliminary.
    Micropost.where("user_id = ?", id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    relationship = active_relationships.find_by(followed_id: other_user.id)
    relationship.destroy
  end

  # Returns true if this user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  #----------------------------------------------------------------------------
  # Private methods
  #----------------------------------------------------------------------------

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
