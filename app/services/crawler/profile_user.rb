module Crawler
  class ProfileUser

    attr :avatar, :decription, :followers, :following, :website, :full_name

    def initialize(avatar:, decription:, followers:, following:, website:, full_name:)
      @avatar     = avatar
      @decription = decription
      @followers  = followers
      @following  = following
      @website    = website
      @full_name  = full_name
    end
  end
end
