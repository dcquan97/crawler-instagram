class Image < Imgur
  mount_uploader :file, FileUploader
  acts_as_paranoid
  belongs_to :instagram
end
