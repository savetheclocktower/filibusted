class CreateCastVotes < ActiveRecord::Migration
  def self.up
    create_table :cast_votes do |t|
      t.column :senator_id, :integer
      t.column :cast_vote_id, :integer
      
      t.column :vote, :boolean

      t.timestamps
    end
  end

  def self.down
    drop_table :cast_votes
  end
end
