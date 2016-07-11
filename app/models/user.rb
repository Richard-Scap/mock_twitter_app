class User < ApplicationRecord
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
	validates :password, presence: true, length: { minimum: 6 }
end