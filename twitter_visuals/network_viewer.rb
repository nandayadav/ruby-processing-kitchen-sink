#Social Graph visualization(followers/friends) for specific twitter profile
require 'lib/twitter_api'
USER = 'jeresig'
PROFILE_SIZE = 48 #Default size of profile image as returned by API

class TwitterNode

  def initialize(x, y, z, size, r, g, b, name)
    @x = x
    @y = y
    @z = z
    @size = size
    @r = r
    @g = g
    @b = b
    @theta = 0
    @orbit_speed = rand * 0.02 + 0.01
    @name = name
  end

  def update
    @theta += @orbit_speed
  end

  def display
    $app.push_matrix 
    $app.rotate(@theta)
    $app.translate(@x, @y, @z)
    $app.fill(@r, @g, @b)
    #$app.sphere(@size)
    $app.text_size(@size/4)
    $app.text(@name, @x, @y, @z)
    $app.pop_matrix 
  end

end

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
    #no_loop
    @results = []
    @twitter_nodes = []
    size 900, 900, OPENGL
    @bg_x, @bg_y, @bg_z = 100, 100, 100
    @initial = true
    @x, @y, @z = nil
    text_font create_font("Georgia", 24, true)
    text_mode(MODEL)
    text_align(CENTER)
  end
  
  def rotate_canvas
    @initial = false
    redraw
  end
  
  def follower_range(results)
    min, max = results.first.followers_count, results.first.followers_count
    results.each do |r| 
      min = r.followers_count if r.followers_count < min
      max = r.followers_count if r.followers_count > max
    end
    min = 1 if min == 0
    return max, min
  end
  
  def mean_count(results)
    sum = results.map(&:followers_count).inject(0){|sum, val| sum + val}
    sum.to_f / results.size.to_f
  end
  
  def build_nodes
    followers if @results.empty?
    
    min_x = 100
    min_y = 100
    max_x = 200
    max_y = 200
    camera#(300.0, 300.0, 1.0, 300.0, 300.0, 0.0, 0.0, 0.0, 0.0)
    max, min = follower_range(@results)
    #puts "Max: #{max}, min: #{min}"
    scaling_factor = 80.0 / mean_count(@results) #for now
    @results.each do |r| 
      x = min_x + rand(max_x - min_x)
      #x = r.followers_count % 700
      y = min_y + rand(max_y - min_y)
      #y = r.followers_count % 700
      z = rand(100)
      m = r.profile_background_color.match /(..)(..)(..)/
      size = scaling_factor * r.followers_count
      size = size > 80 ? 80 : size
      @twitter_nodes << TwitterNode.new(x, y, z, size, m[0].hex, m[1].hex, m[2].hex, r.screen_name)
    end
  end
  
  def draw
    build_nodes if @twitter_nodes.empty?
    background(@bg_x, @bg_y, @bg_z) #To wipe out existing graph 
    x1, y1 = nil, nil
    x_center = width/2
    y_center = height/2
    push_matrix
    #light_specular(255, 255, 255)
    directional_light(255, 255, 204, -1, 0, -1)
    #emissive(1, 1, 1)
    translate(x_center, y_center, 0)

    no_stroke
    @twitter_nodes.each do |t|
      t.update
      t.display
    end
    pop_matrix
  end
  
  # def old_draw
  #   friends if @results.empty?
  #   background(@bg_x, @bg_y, @bg_z) #To wipe out existing graph 
  #   x1, y1 = nil, nil
  #   x_center = width/2
  #   y_center = height/2
  #   radius = 300
  #   segment_angle = 360.0/@results.size.to_f
  #   puts "Segment angle: #{segment_angle}"
  #   puts "Nodes: #{@results.size}"
  #   image_size = segment_angle*4.0 > PROFILE_SIZE ? PROFILE_SIZE : segment_angle*4.0
  #   @results.each_with_index do |result, index|
  #     index += 1
  #     theta = radians(index*segment_angle)
  #     x = (cos(theta) * radius) + x_center
  #     y = (sin(theta) * radius) + y_center
  #     image_url = result.profile_image_url
  #     b = load_image(image_url)
  #     #Smaller images, also to nullify sporadic 'big' profile images returned by twitter API
  #     b.resize(image_size, image_size)
  #     image(b, x, y)
  #     line(x_center, y_center, x, y)
  #   end
  # end
  
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