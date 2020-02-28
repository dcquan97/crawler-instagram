class User < ApplicationRecord
  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password, confirmation: { case_sensitive: true }
  validates_presence_of :password_digest, on: :create, allow_blank: true
  has_secure_password

  before_create { generate_token(:auth_token)}
  before_create { generate_token(:reset_password_token)}

  def send_password_reset
  	generate_token(:reset_password_token)
  	self.reset_password_sent_at = Time.zone.now
  	save
  	UserMailer.password_reset(self).deliver_later
  end

  def generate_token(column)
  	begin
  		self[column] = SecureRandom.urlsafe_base64
  	end while User.exists?(column => self[column])
  end
end
