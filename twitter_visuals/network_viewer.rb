#Social Graph visualization(followers/friends) for specific twitter profile
require 'lib/twitter_api'
USER = 'nandayadav'
PROFILE_SIZE = 48 #Default size of profile image as returned by API

class NetworkViewer < Processing::App
  load_library :control_panel
  def setup
    @client = TwitterClient::DataFetcher.new
    control_panel do |c|
      c.button :friends
      c.button :followers
    end
    no_loop
    @results = []
    size 800, 800
    @bg_x, @bg_y, @bg_z = 100, 100, 100
  end
  
  def draw
    friends if @results.empty?
    background(@bg_x, @bg_y, @bg_z) #To wipe out existing graph 
    x1, y1 = nil, nil
    x_center = width/2
    y_center = height/2
    radius = 300
    segment_angle = 360.0/@results.size.to_f
    puts "Segment angle: #{segment_angle}"
    puts "Nodes: #{@results.size}"
    image_size = segment_angle*4.0 > PROFILE_SIZE ? PROFILE_SIZE : segment_angle*4.0
    @results.each_with_index do |result, index|
      index += 1
      theta = radians(index*segment_angle)
      x = (cos(theta) * radius) + x_center
      y = (sin(theta) * radius) + y_center
      image_url = result.profile_image_url
      b = load_image(image_url)
      #Smaller images, also to nullify sporadic 'big' profile images returned by twitter API
      b.resize(image_size, image_size)
      image(b, x, y)
      line(x_center, y_center, x, y)
    end
  end
  
  def fetch_data(method = 'followers')
    @results = [] #reset
    @results = eval("@client.#{method}('#{USER}')")
  end
  
  #Control Panel methods
  def friends
    fetch_data('friends')
    redraw
  end
  
  def followers
    fetch_data('followers')
    redraw
  end
  
end
NetworkViewer.new :title => "Twitter Social Graph - #{USER}"