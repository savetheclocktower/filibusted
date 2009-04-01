class ClotureVote < ActiveRecord::Base
  belongs_to :meeting
  belongs_to :voteable
  
  has_many :cast_votes
  
  validates_presence_of :voteable_id, :roll_call, :govtrack_id
  
  def self.recent(num=3)
    ClotureVote.find(:all, :order => "date_of_vote DESC", :limit => num)
  end
  
  def self.all_in_current_meeting
    ClotureVote.find(:all, :conditions => { :meeting_id => Meeting.current },
     :order => "date_of_vote ASC")
  end
  
  def self.reset_tweeted_status
    votes = ClotureVote.find(:all)
    votes.each { |v| v.tweeted = false; v.save! }
  end
  
  def nay_votes
    CastVote.find(:all, :include => [:senator], :conditions => {
     :cloture_vote_id => id, :vote => false })
  end
  
  def aye_votes
    CastVote.find(:all, :include => [:senator], :conditions => {
     :cloture_vote_id => id, :vote => true })
  end
  
  def passed?
    total_votes = ayes + nays
    threshold = (total_votes * 0.6)
    if (threshold != threshold.floor)
      threshold = threshold.ceil
    end    
    ayes >= threshold
  end
  
  # i.e., this was the Nth cloture vote of the 111th Congress
  def nth
    num = self.class.all_in_current_meeting.index(self)
    num ? num.ordinalize : nil
  end
  
  def is_in_current_meeting?
    meeting.is_current?
  end
  
  def on_the
    voteable.is_a? Amendment ? :amendment : :bill
  end
  
  def on_amendment?
    voteable.is_a? Amendment
  end
  
  def on_bill?
    voteable.is_a? Bill
  end
  
  def roll_call
    govtrack_id.split('-').last
  end
  
end
