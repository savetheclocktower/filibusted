class Meeting < ActiveRecord::Base
  has_many :cloture_votes

  CURRENT = 11
  
  def votes
    cloture_votes
  end
  
  def is_current?
    id == CURRENT
  end
  
  def self.current
    CURRENT
  end
  
  def nth
    ordinal.ordinalize
  end
  
  def number_of_cloture_votes
    total_cloture_votes || votes.size
  end
  
  def number_of_successful_cloture_votes
    votes.select(&:passed?).size
  end
  
  def pass_rate
    "%3.1f\%" % ((number_of_successful_cloture_votes.to_f /
     number_of_cloture_votes.to_f) * 100)
  end
  
  def obstruction_rate
    return "N/A" if total_votes.nil? || total_votes == 0
    "%3.2f\%" % ((number_of_cloture_votes.to_f / total_votes.to_f) * 100)    
  end
end
