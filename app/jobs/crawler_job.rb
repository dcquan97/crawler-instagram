class CrawlerJob < ActiveJob::Base
  queue_as :crawler

  def perform user
    current_user = user
    crawl = Crawler::Html.new("https://www.instagram.com/#{current_user.username}/")
    crawl.parsing
    crawl.data.each do |n|
      like_counter     = n.like_count
      title            = n.content
      post_id          = n.post_id
      find_post = current_user.instagrams.find_by(post_id: post_id)
      if find_post.nil?
        current_instagram = current_user.instagrams.create(post_id: post_id, content: title, like_counter: like_counter)
      else
        current_instagram = find_post.update_attributes(content: title, like_counter: like_counter)
      end
      instagram_id = current_instagram.id
      image        = n.image
      video        = n.video

      if image.class == String
        Image.create(instagram_id: instagram_id,file: image)
      elsif image != []
        image.each do |image_url|
          Image.create(instagram_id: instagram_id,file: image_url)
        end
      elsif video.class == String
          Video.create(instagram_id: instagram_id,file: video)
      else
        video.each do |video_url|
          Video.create(instagram_id: instagram_id,file: video_url)
        end
      end

    end
    current_user.update status: true
    DoneGetPostJob.set(wait: 2.seconds).perform_later(current_user)
  end
end
