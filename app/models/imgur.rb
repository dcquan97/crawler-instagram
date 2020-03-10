class Imgur < ApplicationRecord
  scope :images, -> { where(type: 'Image') }
  scope :videos, -> { where(type: 'Video') }
  has_many_attached :images
  has_many_attached :videos
end
