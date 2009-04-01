class AddTimeIntervalToMeetings < ActiveRecord::Migration
  def self.up
    add_column "meetings", "years", :string
  end

  def self.down
    remove_column "meetings", "years"
  end
end
