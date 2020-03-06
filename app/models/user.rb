class User < ApplicationRecord
  acts_as_paranoid
  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans

  validates :username, presence: true
  validates :email, presence: true
  validates_presence_of :password_digest, on: :create, allow_blank: true
  validates :password, confirmation: { case_sensitive: true }

  scope :expires_active, ->{ where(confirmation_sent_at: Time.now + 5.minutes) }
  before_create { generate_token(:auth_token)}
  has_secure_password
  has_secure_token :confirmation_token

  def send_password_reset
  	generate_token(:reset_password_token)
  	self.reset_password_sent_at = Time.zone.now
  	save!
  end

  def send_email_activation
    generate_token(:confirmation_token)
    self.confirmation_sent_at = Time.zone.now
    save!
  end

  def send_email_activation_again
    self.regenerate_confirmation_token
    self.confirmation_sent_at = Time.zone.now
    save!
  end

  def generate_token(column)
  	begin
  		self[column] = SecureRandom.urlsafe_base64
  	end while User.exists?(column => self[column])
  end
end

