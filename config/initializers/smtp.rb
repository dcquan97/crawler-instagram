ActionMailer::Base.smtp_settings = {
  domain: 'https://crawler-instagram-website.herokuapp.com/',
  address:        "smtp.gmail.com",
  port:            '587',
  authentication: :plain,
  user_name:      ENV['GMAIL_USERNAME'],
  password:       ENV['GMAIL_PASSWORD'],
  enable_starttls_auto: true
}
