class AssociateVotesWithMeetings < ActiveRecord::Migration
  def self.up
    add_column "cloture_votes", "meeting_id", :integer
  end

  def self.down
    remove_column "cloture_votes", "meeting_id"
  end
end
