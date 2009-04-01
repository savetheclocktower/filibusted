class RenameClotureVotesColumn < ActiveRecord::Migration
  def self.up
    rename_column "meetings", "cloture_votes", "total_cloture_votes"
  end

  def self.down
    rename_column "meetings", "total_cloture_votes", "cloture_votes"
  end
end
