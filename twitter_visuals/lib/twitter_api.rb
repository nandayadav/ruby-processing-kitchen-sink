require 'rubygems'
#Gem.clear_paths
#ENV['GEM_HOME'] = '/usr/lib/jruby-1.4.0/lib/ruby/gems/1.8'
#ENV['GEM_PATH'] = '/usr/lib/jruby-1.4.0/lib/ruby/gems/1.8'
require 'twitter'

module TwitterClient
  class DataFetcher
    attr_accessor :search_results
    def initialize(options = {})
      @options = options
      @search_results = []
      @trend_results = []
    end
    
    def search(tag)
      @search_results = Twitter::Search.new("##{tag}").fetch().results
    end
    
  end
end