class CreateClotureVotes < ActiveRecord::Migration
  def self.up
    create_table :cloture_votes do |t|
      t.timestamps
      t.column "shorthand", :string
      t.column "name", :string
      t.column "ayes", :number
      t.column "nays", :number
      
      t.column "d_ayes", :number
      t.column "d_nays", :number
      t.column "r_ayes", :number
      t.column "r_nays", :number      
    end
  end

  def self.down
    drop_table :cloture_votes
  end
end
