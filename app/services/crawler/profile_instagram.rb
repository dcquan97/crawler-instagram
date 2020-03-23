module Crawler
  class ProfileInstagram

    attr :image, :content, :like_count, :video , :post_id, :time_post, :thumbnail

    def initialize(image:, video:, content:, like_count:, post_id:, time_post:, thumbnail:)
      @image      = image
      @video      = video
      @thumbnail  = thumbnail
      @content    = content
      @like_count = like_count
      @post_id    = post_id
      @time_post  = time_post
    end
  end
end
