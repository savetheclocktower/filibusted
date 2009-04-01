class Voteable < ActiveRecord::Base
  validates_presence_of :govtrack_id  
  
  def cloture_votes
    ClotureVote.find(:all, :conditions => { :voteable_id => id })
  end
end
