#Social Graph visualization(followers/friends) for specific twitter profile
require 'lib/twitter_api'

class Viewer < Processing::App
  def setup
    @client = TwitterClient::DataFetcher.new
    no_loop
    @results = []
    @height, @width = 800, 800
    size @height, @width
  end
  
  
  def draw
    fetch_data#('friends')
    @results.each_with_index do |result, index|
      image_url = result.profile_image_url
      b = loadImage(image_url)
      x, y = rand(@width - 100), rand(@height - 100)
      image(b, x, y)
    end
  end
  
  def fetch_data(method = 'followers')
    @results = [] #reset
    @results = eval("@client.#{method}('ConanOBrien')")
  end
end
Viewer.new :title => "Social Graph"