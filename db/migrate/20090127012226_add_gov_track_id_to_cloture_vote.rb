class AddGovTrackIdToClotureVote < ActiveRecord::Migration
  def self.up
    add_column "cloture_votes", "govtrack_id", :string
  end

  def self.down
    remove_column "cloture_votes", "govtrack_id"
  end
end
