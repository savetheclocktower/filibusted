module SenatorsHelper
  
  PARTIES = {
    "R" => "Republican",
    "D" => "Democrat",
    "I" => "Independent"
  }
  
  def party(senator)
    PARTIES[senator.party]
  end
  
  def photo(senator, size, options = {})
    id = senator.meta[:bioguide_id]
    size ||= :large
    image_tag "senators/#{size}/#{id}.jpg", options    
  end
  
  def trading_card(senator)
    
  end
end
