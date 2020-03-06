require 'open-uri'

module Crawler

  class ProfileInstagram
    attr :key_url, :content, :like_count, :type

    def initialize(key_url:, content:, like_count:, type:)
      @key_url    = key_url
      @content    = content
      @like_count = like_count
      @type       = type
    end
  end

  class Html
    attr_reader :html, :data
    def initialize(url)
      @html = HTTParty.get(url)
      @data = []
    end

    def parsing
      doc       = Nokogiri::HTML(html)
      js_data   = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json      = JSON.parse(js_data.text[21..-2])
      profile   = json["entry_data"]["ProfilePage"][0]
      page_info = profile["graphql"]["user"]["edge_owner_to_timeline_media"]['page_info']
      user_id   = profile["logging_page_id"].delete("profilePage_")
      edges     = profile["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]

      loop_edges(edges)
    end

    def parsing_video_page(html)
      doc             = Nokogiri::HTML(html)
      meta_v          = doc.at_xpath("//meta[@property='og:video']")
      url             = meta_v.attribute_nodes.last.value
      js_data         = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json            = JSON.parse(js_data.text[21..-2])
      shortcode_media = json["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"]
      shortcode_media = json["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"]
      content         = shortcode_media["edge_media_to_caption"]["edges"][0]["node"]["text"]
      like_count      = shortcode_media["edge_media_preview_like"]["count"]
      data << ProfileInstagram.new(key_url: url, content: content, like_count: like_count, type: "video")

      meta_v.attribute_nodes.last.value
    end

    def parsing_photo_page(html)

      doc             = Nokogiri::HTML(html)
      js_data         = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json            = JSON.parse(js_data.text[21..-2])
      shortcode_media = json["entry_data"]["PostPage"][0]["graphql"]["shortcode_media"]
      content         = shortcode_media["edge_media_to_caption"]["edges"][0]["node"]["text"]
      like_count      = shortcode_media["edge_media_preview_like"]["count"]
      image           = shortcode_media["display_url"]

      data << ProfileInstagram.new(key_url: image, content: content, like_count: like_count, type: "image")

      if shortcode_media["edge_sidecar_to_children"]
        shortcode_media["edge_sidecar_to_children"]["edges"]
      else
        shortcode_media["display_url"]
      end
    end

    private

    def parse_post(posts, time)
      @lil_data = []
      posts.each.with_index(1) do |post, index|
        url = post["node"]["is_video"] ?
              post["node"]["video_url"] :
              post["node"]["display_url"]
        @lil_data << url
      end
    end

    def loop_edges(edges)
      edges.each do |edge|
        node     = edge["node"]
        time     = Time.zone.at(node["taken_at_timestamp"]).strftime('%Y-%m-%dT%H:%M')
        page_url = "https://www.instagram.com/p/#{node["shortcode"]}/"

        if node["is_video"]
          url = parsing_video_page(HTTParty.get(page_url))
        else
          shortcode_media = parsing_photo_page(HTTParty.get(page_url))

          if shortcode_media.is_a? Array
            parse_post(shortcode_media, time)
            if data.
          else
            url = shortcode_media
          end
        end
      end
      data
    end
  end
end
