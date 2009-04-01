class Senator < ActiveRecord::Base
  serialize :meta
  
  has_many :cast_votes
  
  def self.all_by_obstruction_rate
    senators = find_all_in_office
    senators.sort_by { |s| -s.obstruction_rate }
  end
  
  # The five least obstructionist in the minority party.
  def self.best_in_minority
    senators = find(:all, :conditions => { :party => "R" })
    senators.sort_by { |s| s.obstruction_rate }[0..4]
  end
  
  # The five most obstructionist in the majority party.
  def self.worst_in_majority
    senators = find(:all, :conditions => { :party => "D" })
    senators.sort_by { |s| -s.obstruction_rate }[0..4]
  end
  
  def self.most_vulnerable
    vulnerable = {
      :r => VULNERABLE_SENATORS[:r].map { |id| Senator.find_by_govtrack_id(id) },
      :d => VULNERABLE_SENATORS[:d].map { |id| Senator.find_by_govtrack_id(id) }
    }
    
    vulnerable
  end
  
  def self.hall_of_blame
    current_meeting = Meeting.find_by_ordinal(111)
    
    senators = find_all_in_office.select do |s| 
      s.obstruction_rate == 1 && s.cast_votes.size ==
       current_meeting.cloture_votes.size
    end
  end
  
  def self.find_all_in_office
    senators = find(:all)
    senators.select { |s| s.in_office? }
  end
  
  def formatted_name
    "#{first_name} #{last_name}"
  end
  
  def epithet
    "(#{party}-#{meta[:state]})"
  end
  
  def in_office?
    in_office
  end
  
  def aye_votes
    CastVote.find(:all, :conditions => { :senator_id => id, :vote => true })
  end
  
  def nay_votes
    CastVote.find(:all, :conditions => { :senator_id => id, :vote => false })
  end
    
  def obstruction_rate
    nay_votes.size.to_f / cast_votes.size.to_f
  end
  
  def obstruction_percentage
    "%3.1f\%" % (obstruction_rate * 100)
  end
  
  
end
