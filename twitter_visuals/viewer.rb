require 'lib/twitter_api'

class Viewer < Processing::App
  
  def setup
    size 1000, 1000
    @results = []
    no_loop
  end
  
  def draw    
    #rect(10,10,20,20)
    fetch_data
    x, y = mouse_x, mouse_y
    @results.each_with_index do |result, index|
      image_url = result.profile_image_url
      b = loadImage(image_url)
      if index.even?
        x += rand(80)
        y += rand(80)
      else
        x -= rand(80)
        y -= rand(80)
      end
      #link(result.source, "_new")
      image(b, x, y)
    end
  end
  
  def fetch_data
    client = TwitterClient::DataFetcher.new
    terms = ['Nepal','Maradona','Kobe','Glen Beck','oscars']
    @results = client.search(terms.sort_by{rand}.first)
  end
  
  def mouse_pressed
    loop
  end
  
  def mouse_released
    no_loop
  end
  
      
end
Viewer.new :title => "Twitter Search - Nepal", :width => 1000, :height => 1000
