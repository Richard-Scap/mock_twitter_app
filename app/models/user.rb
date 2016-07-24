class User < ApplicationRecord
	attr_accessor :remember_token, :activation_token
	before_save   :downcase_email
  before_create :create_activation_digest

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


  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Creates randonly generated token
  def self.new_token
  	SecureRandom.urlsafe_base64
  end

  # Returns the hash digest of the given string (string typically comes from self.new_token)
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Updates token to database for remembering current user session
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets user
  def forget
    update_attribute(:remember_digest, nil)
  end

  private

    def downcase_email
      self.email = email.downcase
      #self.email.downcase!
    end
    
    # Create and assign activation token and digest for user create activation
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
