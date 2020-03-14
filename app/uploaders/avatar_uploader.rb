class AvatarUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  include Cloudinary::CarrierWave

  # Choose what kind of storage to use for this uploader:
  # storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :thumb do
    process resize_to_fill: [100, 100]
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [30, 30]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def public_id
    return "image/" + Cloudinary::Utils.random_public_id
  end
end
