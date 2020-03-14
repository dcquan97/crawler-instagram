module SessionsHelper
  def instagram_images images
    images.each_with_index.map do |image, index|
      active_class = index == 0 ? 'active' : ''
      <<-HTML
        <div class="carousel-item #{active_class}">
          <img src="#{image.file}" class="d-block w-100 img img-fluid">
        </div>
      HTML
    end.reduce(:concat).html_safe
  end

  def instagram_videos videos
    videos.each_with_index.map do |video, index|
      active_class = index == 0 ? 'active' : ''
      <<-HTML
      <div class="carousel-item #{active_class}">
      <!--Mask color-->
        <div class="view">
          <!--Video source-->
          <div class="embed-responsive embed-responsive-1by1">
            <iframe class="embed-responsive-item" src="#{video.file}"></iframe>
          </div>
        </div>
      </div>
      HTML
    end.reduce(:concat).html_safe
  end
end

