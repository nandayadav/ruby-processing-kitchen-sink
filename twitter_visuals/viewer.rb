require 'lib/twitter_api'

class Viewer < Processing::App
  load_library :control_panel
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
      
      @rendered_images << b
      push_matrix
      image(b, x, y)
      case @mode
      when 'BLUR'
        filter(BLUR, 2)
      when 'ERODE'
        filter(ERODE)
      when 'DILATE'
        filter(DILATE)
      end
      pop_matrix
    end
    #blur_old_images
  end
  
  def blur_old_images
    push_matrix
    @rendered_images.each do |img| 
      filter(BLUR,2)
    end
    pop_matrix
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
