class Image < Imgur
  mount_uploaders :file, FileUploader
  acts_as_paranoid
  belongs_to :instagram
end
