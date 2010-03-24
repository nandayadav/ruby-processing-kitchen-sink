require 'net/http'
require 'rubygems'
require 'uri'
require 'json'

module SocialGraph
  URL = 'http://socialgraph.apis.google.com/'
  
  def lookup(params)
    raise "Enter params in hash format" unless params.is_a?(Hash)
    url = URL + "lookup" + build_query(params)
    get_json(url)
  end
  
  def otherme(params)
    raise "Enter params in hash format" unless params.is_a?(Hash)
    url = URL + "otherme" + build_query(params)
    get_json(url)
  end
  
  def testparse(params)
  end
  
  #Normal Get result loaded as Json hash
  private
  def get_json(url)
    response = Net::HTTP.get(URI.parse(url))
    JSON::load(response)
  end
    
  def build_query(hash)
    str = "?"
    hash.each{ |key, val| str += "#{key}=#{val}&" }
    str
  end

end
