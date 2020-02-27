class User < ApplicationRecord
  has_many :instagrams
  has_many :images, through: :instagrams
  has_many :videos, through: :instagrans
end
