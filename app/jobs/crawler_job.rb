require 'open-uri'

class CrawlerJob < ActiveJob::Base
  queue_as :crawler

  def perform user
    current_user = user
    crawl = Crawler::Html.new("https://www.instagram.com/#{current_user.username}/")
    if crawl.html.index("Page Not Found").present?
      ErrorGetPostJob.set(wait: 2.seconds).perform_later(current_user)
    else
      crawl.parsing
      crawl.data_user.each do |user|
        current_user.update(decription: user.decription, website: user.website, full_name: user.full_name, following: user.following, followers: user.followers, avatar: user.  avatar)
      end
      crawl.data.each do |n|
        like_counter     = n.like_count
        title            = n.content
        post_id          = n.post_id
        select_post = current_user.instagrams.find_by(post_id: post_id)
        if select_post.nil?
          current_instagram = current_user.instagrams.create(post_id: post_id, content: title, like_counter: like_counter)
        else
          select_post.update_attributes(content: title, like_counter: like_counter)
          next
        end
        instagram_id = current_instagram.id
        image        = n.image
        video        = n.video
        time_post    = n.time_post
        if image.class == String
          Image.create(instagram_id: instagram_id,file: image)
          download = open(image)
          IO.copy_stream(download, "tmp/image/#{instagram_id}-#{time_post}-image.png")
        elsif image != []
          image.each do |image_url|
            Image.create(instagram_id: instagram_id,file: image_url)
            download = open(image_url)
            IO.copy_stream(download, "tmp/image/#{instagram_id}-#{time_post}-image.png")
          end
        elsif video.class == String
            Video.create(instagram_id: instagram_id,file: video)
            download = open(video)
            IO.copy_stream(download, "tmp/video/#{instagram_id}-#{time_post}-video.mp4")
        else
          video.each do |video_url|
            Video.create(instagram_id: instagram_id,file: video_url)
            download = open(video_url)
            IO.copy_stream(download, "tmp/video/#{instagram_id}-#{time_post}-video.png")
          end
        end

      end
      DoneGetPostJob.set(wait: 2.seconds).perform_later(current_user)
    end
    current_user.update status: true
  end
end
