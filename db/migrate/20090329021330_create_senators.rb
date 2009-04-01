class CreateSenators < ActiveRecord::Migration
  def self.up
    create_table :senators do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      
      t.column :govtrack_id, :string

      t.timestamps
    end
  end

  def self.down
    drop_table :senators
  end
end
