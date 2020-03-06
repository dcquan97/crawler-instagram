require 'open-uri'

module Crawler

  class ProfileInstagram
    attr :key_url, :content, :like_count, :type

    def initialize(image:, video:, content:, like_count:)
      @image      = image
      @video      = video
      @content    = content
      @like_count = like_count
    end
  end

  class Html
    attr_reader :html, :data
    def initialize(url)
      @html  = HTTParty.get(url)
      @data  = []
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
      data << ProfileInstagram.new(image: [], video: url, content: content, like_count: like_count)

      meta_v.attribute_nodes.last.value
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
          url = parsing_video_page(HTTParty.get(page_url))
        else
          shortcode_media_url = parsing_photo_page(HTTParty.get(page_url))
          if shortcode_media_url.is_a? Array
            @video = []
            @img   = []
            shortcode_media_url.each.with_index(1) do |post|
              if post["node"]["is_video"] == true
                @video << post["node"]["video_url"]
              else
                  @img << post["node"]["display_url"]
              end
            end
            media      = shortcode_media(HTTParty.get(page_url))
            content    = media["edge_media_to_caption"]["edges"][0]["node"]["text"]
            like_count = media["edge_media_preview_like"]["count"]
            data << ProfileInstagram.new(image: @img, video: @video, content: content, like_count: like_count)
          else
            shortcode_media_url
            media      = shortcode_media(HTTParty.get(page_url))
            content    = media["edge_media_to_caption"]["edges"][0]["node"]["text"]
            like_count = media["edge_media_preview_like"]["count"]

            data << ProfileInstagram.new(image: shortcode_media_url, video: [], content: content, like_count: like_count)
          end
        end
      end
    end
  end
end
