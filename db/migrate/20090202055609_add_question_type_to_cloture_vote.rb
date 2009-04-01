class AddQuestionTypeToClotureVote < ActiveRecord::Migration
  def self.up
    add_column "cloture_votes", "question_type", :string
  end

  def self.down
    remove_column "cloture_Votes", "question_type"
  end
end
