class User < ApplicationRecord
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
  
  has_secure_password # hashing the password with bcrypt (gemfile)
  
  validates :password, 
    presence: true, 
    length: { minimum: 6 }
  
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
    BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
