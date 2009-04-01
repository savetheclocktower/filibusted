class CreateMeetings < ActiveRecord::Migration
  def self.up
    create_table :meetings do |t|
      t.timestamps
      
      t.column "ordinal", :integer
      t.column "majority_party", :string
      t.column "party_of_president", :string
      
    end
  end

  def self.down
    drop_table :meetings
  end
end
