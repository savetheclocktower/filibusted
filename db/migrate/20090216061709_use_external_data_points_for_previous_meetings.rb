class UseExternalDataPointsForPreviousMeetings < ActiveRecord::Migration
  def self.up
    add_column "meetings", "cloture_votes", :integer
  end

  def self.down
    remove_column "meetings", "cloture_votes"
  end
end
