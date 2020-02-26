class Instagram < ApplicationRecord
  belongs_to :user
  has_many :images , class_name: 'Image'
  has_many :videos , class_name: 'Video'
end
