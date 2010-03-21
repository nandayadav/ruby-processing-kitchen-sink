#Social Graph visualization(followers/friends) for specific twitter profile
require 'lib/twitter_api'
USER = 'shovan'
class NetworkViewer < Processing::App
  def setup
    @client = TwitterClient::DataFetcher.new
    no_loop
    @results = []
    size 800, 800
  end
  
  
  def draw
    fetch_data('friends')
    x1, y1 = nil, nil
    x_center = width/2
    y_center = height/2
    @results.each do |result|
      image_url = result.profile_image_url
      b = loadImage(image_url)
      x, y = rand(width - 100), rand(height - 100)
      #Smaller images, also to nullify sporadic 'big' profile images returned by twitter API
      b.resize(40,40)
      image(b, x, y)
      line(x_center, y_center, x, y)
    end
  end
  
  def fetch_data(method = 'followers')
    @results = [] #reset
    @results = eval("@client.#{method}('#{USER}')")
  end
end
NetworkViewer.new :title => "Twitter Social Graph - #{USER}"