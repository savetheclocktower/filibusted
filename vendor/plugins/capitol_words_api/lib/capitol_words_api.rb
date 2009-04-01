require 'rubygems'
require 'httparty'
require 'pp'

module CapitolWords
  
  class Lawmaker
    include HTTParty
    
    format :json
    base_uri "capitolwords.org"
    

    def self.latest(id, maxrows=10)
      get("/api/lawmaker/#{id}/latest/top#{maxrows}.json")
    end
    
    def self.by_date(id, year, month, day, maxrows=10)
      get("/api/lawmaker/#{id}/#{year}/#{month}/#{day}/top#{maxrows}.json")
    end
    
    def self.by_month(id, year, month, maxrows=10)
      get("/api/lawmaker/#{id}/#{year}/#{month}/top#{maxrows}.json")
    end

    def self.by_year(id, year, maxrows=10)
      get("/api/lawmaker/#{id}/#{year}/top#{maxrows}.json")
    end
    
  end # Lawmaker
  
  class Word
    include HTTParty
    
    format :json    
    base_uri "capitolwords.org"
    
    def self.by_date(word, year, month, day)
      get("/api/word/#{word}/#{year}/#{month}/#{day}/feed.json")
    end
    
    def self.by_month(word, year, month)
      get("/api/word/#{word}/#{year}/#{month}/feed.json")
    end
    
    def self.by_year(word, year)
      get("/api/word/#{word}/#{year}/feed.json")
    end
  end
  
  class WordsOfTheDay
    include HTTParty
    
    format :json
    base_uri "capitolwords.org"
    
    def self.latest(maxrows=10)
      get("/api/wod/latest/top#{maxrows}.json")
    end
    
    def self.by_date(year, month, day, maxrows=10)
      get("/api/wod/#{year}/#{month}/#{day}/top#{maxrows}.json")
    end
    
    def self.by_month(year, month, maxrows=10)
      get("/api/wod/#{year}/#{month}/top#{maxrows}.json")
    end
    
    def self.by_year(year, maxrows=10)
      get("/api/wod/#{year}/top#{maxrows}.json")
    end
    
  end
  
end
