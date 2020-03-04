class Instagram < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :images , class_name: 'Image'
  has_many :videos , class_name: 'Video'
end
