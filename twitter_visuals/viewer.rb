require 'lib/twitter_api'

class Viewer < Processing::App
  load_library :control_panel
  FADE_THRESHOLD = 3
  def setup
    size 1000, 1000
    @results = []
    @rendered_images = []
    control_panel do |c|
      c.button :generate_stuff
      c.menu(:options, ['none', 'blur', 'erode', 'gray','invert','opaque','dilate'], 'none') {|m| modify_image(m) }
    end
    no_loop
    @link = nil
    @client = TwitterClient::DataFetcher.new
    @terms = ['Nepal','Maradona','Kobe','Glen Beck','oscars']
    @mode = nil
    @bg_x, @bg_y, @bg_z = 100, 100, 100
    background(@bg_x, @bg_y, @bg_z)
  end
  
  def modify_image(mode)
    if ['none','other'].include?(mode)
      @mode = nil
    else
      @mode = mode.upcase 
    end
    redraw
  end
    
  
  def generate_stuff
    redraw
  end
  
  def draw    
    #rect(10,10,20,20)
    fetch_data
    x, y = mouse_x, mouse_y
    filter_old_images
    @results.each_with_index do |result, index|
      #sleep 1
      image_url = result.profile_image_url
      b = loadImage(image_url)
      if index.even?
        x += rand(80)
        y += rand(80)
      else
        x -= rand(80)
        y -= rand(80)
      end
      @link = result.source
      puts "Link: #{@link}"
      
      @rendered_images << {:image => b, :x => x, :y => y, :counter => 0}
      # push_matrix
      #       case @mode
      #       when 'BLUR'
      #         b.filter(BLUR, 2)
      #       when 'ERODE'
      #         b.filter(ERODE)
      #       when 'DILATE'
      #         b.filter(DILATE)
      #       end
      image(b, x, y)
      #pop_matrix
    end
    
  end
  
  #Replace image pixels with background pixels
  def fade_image(image)
    img = image[:image]
    x,y = image[:x], image[:y]
    dimension = (img.width*img.height)
    img.load_pixels
    (0..dimension-1).each do |i|
      img.pixels[i] = color(@bg_x, @bg_y, @bg_z)
    end
    img.update_pixels
    image(img,x,y)
  end
    
  #Apply various image filters
  def filter_old_images
    @rendered_images.each do |i| 
      img = i[:image]
      case @mode
      when 'ERODE'
        img.filter(ERODE)
      when 'DILATE'
        img.filter(DILATE)
      else
        img.filter(BLUR,4)
      end
      #img.resize(img.width/2, img.height/2)
      image(img, i[:x], i[:y])
      i[:counter] += 1
      fade_image(i) if i[:counter] > FADE_THRESHOLD
    end
  end
  
  def fetch_data
    @results = []
    @results = @client.search(@terms.sort_by{rand}.first)
  end
  
  def mouse_pressed
    loop
  end
  
  def mouse_released
    no_loop
    link(@link, "_new")
  end
  
      
end
Viewer.new :title => "Twitter Search - Nepal", :width => 1000, :height => 1000
