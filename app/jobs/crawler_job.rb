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
      page_info       = crawl.next_page.first
      user_id         = crawl.next_page[-1]
      data_parsing    = [] + crawl.data
      crawl_next_page = Crawler::Json.new(page_info, user_id, data_parsing)
      crawl_next_page.parsing
      crawl_next_page.data.each do |n|
        like_counter     = n.like_count
        title            = n.content
        post_id          = n.post_id
        time_post        = n.time_post
        select_post = current_user.instagrams.find_by(post_id: post_id)

        if select_post.nil?
          current_instagram = current_user.instagrams.create(post_id: post_id, content: title, like_counter: like_counter, time_post: time_post)
        else
          select_post.update(content: title, like_counter: like_counter)
          next
        end

        instagram_id = current_instagram.id
        image        = n.image
        video        = n.video
        thumbnail    = n.thumbnail
        time_post    = n.time_post

        if image.class == String
          download     = open(image)
          number       = rand(100) + "#{Time.now}"
          IO.copy_stream(download,Rails.root.to_s + "/public/uploads/images/#{instagram_id}#{number}.png")
          url_img = open(Rails.root.to_s + "/public/uploads/images/#{instagram_id}#{number}.png")
          Image.create!(instagram_id: instagram_id,file: url_img,thumbnail: url_img)
        elsif image != []
          image.each do |image_url|
            number       = rand(100)
            download = open(image_url)
            IO.copy_stream(download,Rails.root.to_s + "/public/uploads/images/#{instagram_id}#{number}.png")
            url_img = open(Rails.root.to_s + "/public/uploads/images/#{instagram_id}#{number}.png")
            Image.create!(instagram_id: instagram_id,file: url_img,thumbnail: url_img)
          end
        elsif video.class == String
            number       = rand(100)
            download_videos = open(video)
            download_thumbnail = open(thumbnail)

            IO.copy_stream(download_videos,Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.mp4")
            url_video = open(Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.mp4")

            IO.copy_stream(download_thumbnail,Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.png")
            url_thumbnail = open(Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.png")

            Video.create!(instagram_id: instagram_id,file: url_video,thumbnail: url_thumbnail)
        else
          video.each do |video_url|
            number       = rand(100)
            download_videos = open(video)
            download_thumbnail = open(thumbnail)

            IO.copy_stream(download_videos,Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.mp4")
            url_video = open(Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.mp4")

            IO.copy_stream(download_thumbnail,Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.png")
            url_thumbnail = open(Rails.root.to_s + "/public/uploads/videos/#{instagram_id}#{number}.png")

            Video.create!(instagram_id: instagram_id,file: url_video,thumbnail: url_thumbnail)
          end
        end
        # crawl_next_page = Crawler::Job.new()
      end

      crawl.data_user.each do |users|
        download     = open(users.avatar)
        IO.copy_stream(download,Rails.root.to_s + "/public/uploads/avt/avatar.png")
        url_avt = File.open(Rails.root.to_s + "/public/uploads/avt/avatar.png")
        current_user.update(decription: users.decription, website: users.website, full_name: users.full_name, following: users.following, followers: users.followers)
        current_user.status = true
        current_user.avatar = url_avt
        current_user.save!
      end
      DoneGetPostJob.set(wait: 2.seconds).perform_later(current_user)
    end
  end
end
