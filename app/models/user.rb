class User < ApplicationRecord
  acts_as_paranoid
  has_secure_password

  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans
end

