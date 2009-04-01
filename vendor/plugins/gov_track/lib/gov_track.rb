require 'hpricot'
require 'open-uri'

module GovTrack
  
  DATA_URL = "http://govtrack.us/data/us/%s"
  
  class Meeting
    
    def initialize(meeting)
      @base_url = GovTrack::DATA_URL % meeting
    end
    
    def senate_votes
      votes(:senate)
    end
    
    def house_votes
      votes(:house)
    end
    
    def votes(where=nil)
      return @votes if @votes      
      doc = Hpricot::XML( open("#{@base_url}/votes.all.index.xml") )
      
      xpath = "//vote"
      xpath << "[@where='#{where}']" if where
      
      @votes = (doc / xpath).map { |node| GovTrack::Vote.new(node) }      
    end
    
  end
  
  class Vote
    
    ATTRIBUTES = [:id, :date, :where, :roll, :title, :result, :counts,
      :bill_id, :bill_title, :amendment_id, :amendment_title]
    
    attr_accessor *ATTRIBUTES
    
    def initialize(node)

      Vote::ATTRIBUTES.each do |attribute|
        instance_variable_set("@#{attribute}", node[attribute])
      end
      
      @date   = Time.zone.at(@date.to_i)
      @where  = @where.to_sym
      @result = @result.to_sym

    end
    
    def breakdown
      
      # Here's where we need to screen-scrape, sadly.
      
    end
    
  end
  
end