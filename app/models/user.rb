class User < ApplicationRecord
  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans

  def password=(new_password)
    @password = new_password
    self.encrypted_password = password_digest(@password) if @password.present?
  end

end
