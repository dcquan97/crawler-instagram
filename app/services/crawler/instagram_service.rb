module Crawler
  class ProfileInstagram
    attr :content, :image, :video

    def initialize(content:, image:, video:)
      @content = content
      @image = image
      @video = video
    end
  end

  class InstagramService
    attr_reader :key, :data
    URL = "https://www.instagram.com".freeze

    def initialize(code:)
      @key = code
    end

    def execute
      standardized_data(progess_fetch_data)
    end

    private

    def progess_fetch_data
      html    = HTTParty.get(url(key))
      doc     = Nokogiri::HTML(html)
      js_data = doc.at_xpath("//script[contains(text(),'window._sharedData')]")
      json    = convert_js_data_to_json(js_data)
      profile = json["entry_data"]["ProfilePage"][0]
      data    = profile["graphql"]["user"]["edge_owner_to_timeline_media"]["edges"]
    end

    def standardized_data(datas)
      return [] if datas.size.zero?
      # edges[1]["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"]
      @data = []
      datas.each do |datum|
        content = datum["node"]["edge_media_to_caption"]["edges"][0]["node"]["text"]
        data << ProfileInstagram.new(content: content, image: nil, video: nil)
      end
      data
    end

    def url(segment)
      "#{URL}/#{segment}"
    end

    def convert_js_data_to_json(js_data)
      first_letter = js_data.text.index('{')
      last_letter  = (js_data.text.reverse.index('}').to_i + 1) * (-1)
      JSON.parse(js_data.text[first_letter..last_letter])
    end
  end
end
