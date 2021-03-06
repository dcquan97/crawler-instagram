class User < ApplicationRecord
  acts_as_paranoid

  mount_uploader :avatar, AvatarUploader

  has_secure_password
  has_secure_token :confirmation_token

  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans

  validates :username, presence: true
  validates :email, presence: true
  validates_presence_of :password_digest, on: :create, allow_blank: true
  validates :password, confirmation: { case_sensitive: true }

  before_create { generate_token(:auth_token)}

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


  def remember
    generate_token(:remember_token)
    save!
  end

  def authenticated?(remember_token)
    return false if remember_token.nil?
    BCrypt::Password.new(remember_token).is_password?(remember_token)
  end

  def forget
    self.update(remember_token: nil)
  end
end
