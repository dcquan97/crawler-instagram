class Imgur < ApplicationRecord
  scope :images, -> { where(type: 'Image') }
  scope :videos, -> { where(type: 'Video') }
end
