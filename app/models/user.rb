class User < ApplicationRecord
  acts_as_paranoid
  has_attached_file :avatar,
                    styles: {
                      thumb: "100x100#",
                      small: "150x150>",
                      medium: "200x200"
                    },
                    url: "https://f000.backblazeb2.com",
                    path: ":attachment/:id/:style/:filename",
                    storage: :backblaze,
                    b2_credentials: {
                      account_id: '7eeeecf0aba4',
                      application_key: '00030ec35b90b187036671d7a3e6c14268f04f36ce',
                      bucket: 'crawler-instagram'
                    },
                    hash_secret: "longSecretString"
  has_secure_password
  has_secure_token :confirmation_token

  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans

  validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/jpg image/png)
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
end

