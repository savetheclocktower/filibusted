class AddTotalRollCallVotesInMeeting < ActiveRecord::Migration
  def self.up    
    add_column "meetings", "total_votes", :integer    
  end

  def self.down
    remove_column "meetings", "total_votes"
  end
end
