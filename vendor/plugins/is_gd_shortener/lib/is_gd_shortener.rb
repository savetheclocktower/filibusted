require 'hpricot'
require 'open-uri'

module IsGd
  API_URL = "http://is.gd/api.php?longurl=%s"
  
  def self.url(url)
    Hpricot( open(API_URL % url) )
  end
end