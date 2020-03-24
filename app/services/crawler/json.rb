module Crawler
  class Json

    attr_reader :page_info, :user_id, :data

    def initialize(page_info, user_id, data_parsing)
      @page_info = page_info
      @user_id   = user_id
      @data      = [] + data_parsing
    end

    def parsing
      begin
        end_cursor = page_info["end_cursor"][0..-3]
        url        = next_url(end_cursor, user_id)
        json       = HTTParty.get(url)
        @page_info = json["data"]["user"]["edge_owner_to_timeline_media"]["page_info"]
        edges      = json["data"]["user"]["edge_owner_to_timeline_media"]["edges"]

        loop_edges(edges)
      end while page_info["has_next_page"]
    end

    def check_post(node)
      if node["edge_sidecar_to_children"]
        node["edge_sidecar_to_children"]["edges"]
      else
        node["display_url"]
      end
    end

    private

    def loop_edges(edges)
      edges.each do |edge|
        node     = edge["node"]
        time     = Time.zone.at(node["taken_at_timestamp"]).strftime('%Y-%m-%dT%H:%M')
        page_url = "https://www.instagram.com/p/#{node["shortcode"]}/"

        if node["is_video"]
          url           = node["video_url"]
          check_content = node.dig("edge_media_to_caption","edges")&.first
            if check_content.nil?
              content   = ""
            else
              content   = check_content.dig("node","text")
            end
          like_count    = node["edge_media_preview_like"]["count"]
          post_id       = node["id"]
          data << ProfileInstagram.new(image: [], video: url, content: content, like_count: like_count, post_id: post_id, time_post: time)
        else
          shortcode_media_url = check_post(node)
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
            check_content = node.dig("edge_media_to_caption","edges")&.first
            if check_content.nil?
              content  = ""
            else
              content  = check_content.dig("node","text")
            end
            like_count = node["edge_media_preview_like"]["count"]
            post_id    = node["id"]
            data << ProfileInstagram.new(image: @img, video: @video, content: content, like_count: like_count, post_id: post_id, time_post: time)
          else
            shortcode_media_url
            check_content = node.dig("edge_media_to_caption","edges")&.first
            if check_content.nil?
              content = ""
            else
              content     = check_content.dig("node","text")
            end
            like_count    = node["edge_media_preview_like"]["count"]
            post_id       = node["id"]
            data << ProfileInstagram.new(image: shortcode_media_url, video: [], content: content, like_count: like_count, post_id: post_id, time_post: time)
          end
        end
      end
    end

    def next_url(end_cursor, user_id)
      "https://www.instagram.com/graphql/query/?query_hash=e769aa130647d2354c40ea6a439bfc08&variables=%7B%22id%22%3A%22#{user_id}%22%2C%22first%22%3A12%2C%22after%22%3A%22#{end_cursor}%3D%3D%22%7D"
    end
  end
end
