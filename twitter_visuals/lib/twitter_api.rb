require 'rubygems'
require 'twitter'

module TwitterClient
  class DataFetcher

    def initialize(options = {})
      @options = options
      @search_results = []
    end
    
    def search(tag)
      @search_results = Twitter::Search.new("##{tag}").fetch().results
    end
    
    def friends(screen_name = nil)
      authorize_and_base if @client.nil?
      return @client.friends(:screen_name => screen_name) if screen_name && !screen_name.empty?
      @client.friends
    end
    
    def followers(screen_name = nil)
      authorize_and_base if @client.nil?
      return @client.followers(:screen_name => screen_name) if screen_name && !screen_name.empty?
      @client.followers
    end
    
    def follower_ids(screen_name = nil)
      authorize_and_base if @client.nil?
      return @client.follower_ids(:screen_name => screen_name) if screen_name && !screen_name.empty?
      @client.follower_ids
    end
    
    def friend_ids(screen_name = nil)
      authorize_and_base if @client.nil?
      return @client.friend_ids(:screen_name => screen_name) if screen_name && !screen_name.empty?
      @client.friend_ids
    end
    
    private
    
    def authorize_and_base
      cred = YAML::load(File.open(File.dirname(__FILE__) + '/../config/credentials.yml'))
      @httpauth ||= Twitter::HTTPAuth.new(cred['email'], cred['password'])
      @client ||= Twitter::Base.new(@httpauth)
    end
    
  end
end