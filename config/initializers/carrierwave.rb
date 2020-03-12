# Configure cloudinary
Cloudinary.config do |config|
	config.cloud_name = 'tomosia'
	config.api_key = '995845143971292'
	config.api_secret = 'wW_LZhao1GM95EOQ6FNyd9GJXlQ'
	config.secure = true
	config.cdn_subdomain = true
	config.ignore_integrity_errors = false
	config.ignore_processing_errors = false
	config.ignore_download_errors = false
end
CarrierWave.configure do |config|
	config.cache_storage = :file
end