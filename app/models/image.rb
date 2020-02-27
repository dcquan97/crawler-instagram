class Image < Imgur
  acts_as_paranoid
  belongs_to :instagram
end
