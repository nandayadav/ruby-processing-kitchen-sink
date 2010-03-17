#Social Graph visualization(followers/friends) for specific twitter profile
require 'lib/twitter_api'
USER = 'nandayadav'
class NetworkViewer < Processing::App
  def setup
    @client = TwitterClient::DataFetcher.new
    no_loop
    @results = []
    @height, @width = 800, 800
    size @height, @width
  end
  
  
  def draw
    fetch_data('friends')
    @results.each do |result|
      image_url = result.profile_image_url
      b = loadImage(image_url)
      x, y = rand(@width - 100), rand(@height - 100)
      image(b, x, y)
    end
  end
  
  def fetch_data(method = 'followers')
    @results = [] #reset
    @results = eval("@client.#{method}('#{USER}')")
  end
end
NetworkViewer.new :title => "Twitter Social Graph - #{USER}"