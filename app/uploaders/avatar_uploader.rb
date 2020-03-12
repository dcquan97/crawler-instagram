class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  # Choose what kind of storage to use for this uploader:
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process :convert => 'png'
  process :tags => ['post_picture']

  version :standard do
    process :resize_to_fill => [100, 150, :north]
  end
  version :thumbnail do
    resize_to_fit(100, 100)
  end
  def public_id
    Cloudinary::PreloadedFile.split_format(original_filename).first + "_" + Cloudinary::Utils.random_public_id[0, 100]
  end
end
