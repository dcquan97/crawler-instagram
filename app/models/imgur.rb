class Imgur < ApplicationRecord
  mount_uploaders :file, FileUploader
  scope :images, -> { where(type: 'Image') }
  scope :videos, -> { where(type: 'Video') }
end
