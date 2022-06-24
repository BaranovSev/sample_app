class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                  foreign_key: "followed_id",
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token # non DB attribute of User class

  before_save { self.email = email.downcase } # Active Record Callback 
  
  validates :name, 
    presence: true, 
    length: { maximum: 50 }
  
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  
  validates :email, 
    presence: true, # not empty
    length: { maximum: 255 }, # max lenght of email is 255
    format: {with: VALID_EMAIL_REGEX }, # set special format
    uniqueness: {case_sensitive: false } # email is unique vith no matter upcase or lowcase
  
  has_secure_password # hashing the password with bcrypt (gemfile) / catch nil password
  validates :password, 
    presence: true, 
    length: { minimum: 6 },
    allow_nil: true # for testing (has_secure_password catch nil)
  
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token. Used in theme 'permanent cookies'
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    # using 'self' -> concrete obj User has remember token
    update_attribute(:remember_digest, User.digest(remember_token))
    # update DB with encrypted token
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget user
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Defines a proto-feed.
  # See "Following users" for the full implementation.
  def feed
    following_ids = "SELECT followed_id FROM relationships
    WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
    OR user_id = :user_id", user_id: id)
    # Micropost.where("user_id = ?", id) # only self posts / user_id = ? prevents SQL injection
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end
  
  # Unfollows a user.
  def unfollow(other_user)
  following.delete(other_user)
  end
  
  # Returns true if the current user is following the other user.
  def following?(other_user)
  following.include?(other_user)
  end

  #private
end
