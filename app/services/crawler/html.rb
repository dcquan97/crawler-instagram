module Crawler
  class Html

    attr_reader :html, :data , :data_user, :next_page

    def initialize(url)
      @html      = HTTParty.get(url)
      @data      = []
      @data_user = []
      @next_page = []
    end

    def parsing
      doc           = Nokogiri::HTML(html)
      js_data       = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json          = JSON.parse(js_data.text[21..-2])
      profile       = json["entry_data"]["ProfilePage"][0]
      page_info     = profile["graphql"]["user"]["edge_owner_to_timeline_media"]['page_info']
      user_id       = profile["logging_page_id"].delete("profilePage_")
      edges         = profile["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
      decription    = profile["graphql"]["user"]["biography"]
      check_website = profile["graphql"]["user"]["external_url"]
      if check_website.nil?
        website = ""
      else
        website = check_website
      end

      check_full_name  = profile["graphql"]["user"]["full_name"]
      if check_full_name.nil?
        full_name = ""
      else
        full_name = check_full_name
      end

      following  = profile["graphql"]["user"]["edge_follow"]["count"]
      followers  = profile["graphql"]["user"]["edge_followed_by"]["count"]
      avatar     = profile["graphql"]["user"]["profile_pic_url_hd"]
      data_user << ProfileUser.new(avatar: avatar, website: website, full_name: full_name, followers: followers, following: following, decription: decription)

      loop_edges(edges)

      next_page << page_info
      next_page << user_id
    end

    def shortcode_media(html)
      doc             = Nokogiri::HTML(html)
      js_data         = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json            = JSON.parse(js_data.text[21..-2])
      json["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"]
    end

    def parsing_photo_page(html)
      doc             = Nokogiri::HTML(html)
      js_data         = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json            = JSON.parse(js_data.text[21..-2])
      shortcode_media = json["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"]

      if shortcode_media["edge_sidecar_to_children"]
        shortcode_media["edge_sidecar_to_children"]["edges"]
      else
        shortcode_media["display_url"]
      end
    end

    private

    def loop_edges(edges)
      edges.each do |edge|
        node     = edge["node"]
        time     = Time.zone.at(node["taken_at_timestamp"]).strftime('%Y-%m-%dT%H:%M')
        page_url = "https://www.instagram.com/p/#{node["shortcode"]}/"

        if node["is_video"]
          doc             = Nokogiri::HTML(HTTParty.get(page_url))
          meta_v          = doc.at_xpath("//meta[@property='og:video']")
          url             = meta_v.attribute_nodes.last.value
          js_data         = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
          json            = JSON.parse(js_data.text[21..-2])
          shortcode_media = json["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"]
          thumbnail       = shortcode_media["display_url"]
          check_content = shortcode_media.dig("edge_media_to_caption","edges")&.first
            if check_content.nil?
              content = ""
            else
              content       = check_content.dig("node","text")
            end
          like_count      = shortcode_media["edge_media_preview_like"]["count"]
          post_id         = node["id"]
          data << ProfileInstagram.new(image: [], video: url, content: content, like_count: like_count, post_id: post_id, time_post: time)
        else
          shortcode_media_url = parsing_photo_page(HTTParty.get(page_url))
          if shortcode_media_url.is_a? Array
            @video = []
            @img   = []
            shortcode_media_url.each.with_index(1) do |post|
              if post["node"]["is_video"]
                @video << post["node"]["video_url"]
              else
                  @img << post["node"]["display_url"]
              end
            end
            media      = shortcode_media(HTTParty.get(page_url))
            check_content = media.dig("edge_media_to_caption","edges")&.first
            if check_content.nil?
              content = ""
            else
              content       = check_content.dig("node","text")
            end
            like_count = media["edge_media_preview_like"]["count"]
            post_id    = node["id"]
            data << ProfileInstagram.new(image: @img, video: @video, content: content, like_count: like_count, post_id: post_id, time_post: time)
          else
            shortcode_media_url
            media         = shortcode_media(HTTParty.get(page_url))
            check_content = media.dig("edge_media_to_caption","edges")&.first
            if check_content.nil?
              content = ""
            else
              content     = check_content.dig("node","text")
            end
            like_count    = media["edge_media_preview_like"]["count"]
            post_id       = node["id"]
            data << ProfileInstagram.new(image: shortcode_media_url, video: [], content: content, like_count: like_count, post_id: post_id, time_post: time)
          end
        end
      end
    end
  end
end
