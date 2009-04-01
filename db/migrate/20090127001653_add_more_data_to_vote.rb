class AddMoreDataToVote < ActiveRecord::Migration
  def self.up
    
    change_column "cloture_votes", "ayes", :integer
    change_column "cloture_votes", "nays", :integer
    
    change_column "cloture_votes", "d_ayes", :integer
    change_column "cloture_votes", "r_ayes", :integer
    change_column "cloture_votes", "d_nays", :integer
    change_column "cloture_votes", "r_nays", :integer
    
    add_column "cloture_votes", "date_of_vote", :datetime
    add_column "cloture_votes", "meeting", :integer
    add_column "cloture_votes", "vote_title", :string
    
    rename_column "cloture_votes", "name", "bill_title"
  end

  def self.down
    
    change_column "cloture_votes", "ayes", :number
    change_column "cloture_votes", "nays", :number
 
    change_column "cloture_votes", "d_ayes", :number
    change_column "cloture_votes", "r_ayes", :number
    change_column "cloture_votes", "d_nays", :number
    change_column "cloture_votes", "r_nays", :number
    
    remove_column "cloture_votes", "date_of_vote"
    remove_column "cloture_votes", "meeting"
    remove_column "cloture_votes", "vote_title"
     
    rename_column "cloture_votes", "bill_title", "name"
     
  end
end
