class User < ApplicationRecord
  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :password, confirmation: { case_sensitive: true }
  has_secure_password
end
