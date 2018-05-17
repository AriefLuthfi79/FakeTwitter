class User < ApplicationRecord
  attr_accessor :remember_token

  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true,length: { maximum: 255 }, 
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  # Returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost) 
  end

  # Remember a user in the database for use in session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns random token
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # Return true if remember token match value of attribute remember_digest in the table user
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forget the users
  def forget
    update_attribute(:remember_digest, nil)
  end
end
