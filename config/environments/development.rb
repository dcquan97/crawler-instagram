Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true
  Paperclip.options[:command_path] = "/usr/local/bin/"

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp', 'caching-dev.txt').exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the backblaze file system (see config/storage.yml for options)
  config.active_storage.service = :backblaze

  # Using sidekiq to create queue when send mailer
  config.active_job.queue_adapter = :sidekiq

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  # SMTP settings for gmail
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  config.action_mailer.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :authentication       => "plain",
    :user_name            => ENV['gmail_username'],
    :password             => ENV['gmail_password'],
    :domain               => 'gmail.com',
    :enable_starttls_auto => true
  }
  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log


  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true
  # Use environment to access send email to account gmail
  config.action_mailer.default_url_options = { host: 'localhost:3000' }

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.paperclip_defaults = {
    storage: :backblaze,
    fog_credentials: {
      provider: 'backblaze',
      account_id: '7eeeecf0aba4',
      application_key: '0003c78b33077a5ac0ab1f59f5a6bc2e00f70527a9',
      bucket: 'crawler-instagram',
    },
    fog_directory: 'crawler-instagram',
    fog_host: 'https://f000.backblazeb2.com/file/crawler-instagram/'
  }

end
