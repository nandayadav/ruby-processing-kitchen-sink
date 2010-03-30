#Social Graph visualization(followers/friends) for specific twitter profile
require 'lib/twitter_api'
USER = 'billmaher'
PROFILE_SIZE = 48 #Default size of profile image as returned by API

class NetworkViewer < Processing::App
  load_library :control_panel
  load_library :opengl
  include_package 'processing.opengl'
  def setup
    @client = TwitterClient::DataFetcher.new
    control_panel do |c|
      c.button :friends
      c.button :followers
      c.button :rotate_canvas
    end
    no_loop
    @results = []
    size 800, 800, OPENGL
    @bg_x, @bg_y, @bg_z = 100, 100, 100
    @initial = true
    @x, @y, @z = 10.0, 10.0, 1.0
    text_font create_font("Georgia", 12, true)
  end
  
  def rotate_canvas
    @initial = false
    redraw
  end
  
  def draw
    if @initial
    followers if @results.empty?
    background(@bg_x, @bg_y, @bg_z) #To wipe out existing graph 
    x1, y1 = nil, nil
    x_center = width/2
    y_center = height/2
    no_stroke
    lights
    min_x = 100
    min_y = 100
    max_x = 700
    max_y = 700
    camera#(300.0, 300.0, 1.0, 300.0, 300.0, 0.0, 0.0, 0.0, 0.0)
    @results.each do |r|
      x = min_x + rand(max_x - min_x)
      y = min_y + rand(max_y - min_y)
      z = rand(100)
      #z = 0
      push_matrix 
      translate(x, y, z)
      color = r.profile_background_color
      name = r.screen_name
      m = color.match /(..)(..)(..)/
      fill(m[1].hex, m[2].hex, m[3].hex)
      sphere(rand(50))
      #text(name, x, y, z)
      pop_matrix
    end
    #@initial = false
  else
    @x += 1.0
    @y += 1.0
    @z += 0.1
    #camera(@x, @y, @z, @x, @y, 0.0, 0.0, 0.0, 0.0)
    sphere(rand(100))
    
  end
      #push_matrix
      #rotate(1)
      #pop_matrix
  end
  
  def old_draw
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
  
  def friend_ids
    fetch_data('friend_ids')
    redraw
  end
  
  def followers
    fetch_data('followers')
    redraw
  end
  
end
NetworkViewer.new :title => "Twitter Social Graph - #{USER}"