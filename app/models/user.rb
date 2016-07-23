class User < ApplicationRecord
	attr_accessor :remember_token
	before_save { self.email = email.downcase }

	#validate name
	validates :name,  presence: true, length: {maximum: 50}
	#validate email using VALID_EMAIL_REGEX expression
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
	validates :email, presence: true, length: {maximum: 255}, 
		format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
	#secure password
	has_secure_password
	validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


  # Returns the hash digest of the given string
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Creates randonly generated token
  def self.new_token
  	SecureRandom.urlsafe_base64
  end

  # Updates token to database for remembering current user session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(remember_token)
    if remember_digest.nil?
      false
    else
      BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end
  end

  # Forgets user
  def forget
    update_attribute(:remember_digest, nil)
  end
end
