module Crawler
  class ProfileInstagram

    attr :image, :content, :like_count, :video , :post_id, :time_post

    def initialize(image:, video:, content:, like_count:, post_id:, time_post:)
      @image      = image
      @video      = video
      @content    = content
      @like_count = like_count
      @post_id    = post_id
      @time_post  = time_post
    end
  end
end
