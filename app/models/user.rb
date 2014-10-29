require 'securerandom'

class User < ActiveRecord::Base
	before_validation :set_key
	after_create :send_email

	has_many :problems
	has_many :notes

	validates :name, presence: true

	validates :email,
	          presence: true,
	          uniqueness: { case_sensitive: false },
	          format: { with: /\A[\w\-\.]+@[\w\-\.]+\Z/, message: "must be a valid email address" }

	has_secure_password

	def set_key
		self.activation_key = SecureRandom.uuid
	end

	def send_email
		UserMailer.account_activation(id).deliver
	end
end
