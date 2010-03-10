require 'lib/twitter_api'

class Viewer < Processing::App
  #load_library :opengl
  #include_package 'processing.opengl'
  def setup
    size 1000, 1000#, OPENGL
    @results = []
    no_loop
  end
  
  def draw    
    rect(10,10,20,20)
    fetch_data
    x, y = 0, 0
    @results.each do |result|
      image_url = result.profile_image_url
      b = loadImage(image_url)
      x += 50
      y += 50
      link(result.source, "_new")
      image(b, x, y)
    end
  end
  
  def fetch_data
    client = TwitterClient::DataFetcher.new
    @results = client.search("nepal")
  end
  
      
end
Viewer.new :title => "3D Visualization", :width => 1000, :height => 1000
