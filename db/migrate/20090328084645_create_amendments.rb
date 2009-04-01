class CreateAmendments < ActiveRecord::Migration
  def self.up
    create_table :amendments do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :amendments
  end
end
