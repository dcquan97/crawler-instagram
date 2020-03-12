class Instagram < ApplicationRecord
  acts_as_paranoid
  belongs_to :user
  has_many :images , class_name: 'Image'
  has_many :videos , class_name: 'Video'

  scope :order_by_time_post, -> {
    order(time_post: :desc)
  }
end
