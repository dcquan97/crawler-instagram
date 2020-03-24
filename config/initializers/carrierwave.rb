# Configure cloudinary
Cloudinary.config do |config|
	config.cloud_name = 'dcqbean'
	config.api_key = '251127759461936'
	config.api_secret = 'CEHW5Ugu1dfevM7qxnToJV1Is-o'
	config.secure = true
	config.cdn_subdomain = true
	config.ignore_integrity_errors = false
	config.ignore_processing_errors = false
	config.ignore_download_errors = false
end
CarrierWave.configure do |config|
	config.cache_storage = :file
end
