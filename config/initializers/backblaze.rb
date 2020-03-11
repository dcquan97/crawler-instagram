require "fog/backblaze"
require 'json'
require 'net/http'

connection = Fog::Storage.new(
  provider: 'backblaze',

  # with one key (more secure)
  # b2_key_id: 'xxxx',
  # b2_key_token: 'zzzxxxccc'

  # full access to b2 account (less secure)
  b2_account_id: '00030ec35b90b187036671d7a3e6c14268f04f36ce',
  b2_account_token: '7eeeecf0aba4',

  # optional, used to make some operations faster
  b2_bucket_name: 'crawler-instagram',
  b2_bucket_id: '87cefefefe6cafd07a0b0a14',

  logger: Logger.new(STDOUT).tap {|l|
    l.formatter = proc {|severity, datetime, progname, msg|
      "#{severity.to_s[0]} - #{datetime.strftime("%T.%L")}: #{msg}\n"
    }
  }
)
# Paperclip::Attachment.default_options[:url] = 'crawler-instagram.b2.backblaze.com'
# Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'