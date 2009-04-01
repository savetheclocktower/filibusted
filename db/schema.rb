# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090331123825) do

  create_table "amendments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cast_votes", :force => true do |t|
    t.integer  "senator_id"
    t.integer  "cloture_vote_id"
    t.boolean  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cloture_votes", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shorthand"
    t.string   "bill_title"
    t.integer  "ayes"
    t.integer  "nays"
    t.integer  "d_ayes"
    t.integer  "d_nays"
    t.integer  "r_ayes"
    t.integer  "r_nays"
    t.datetime "date_of_vote"
    t.integer  "meeting"
    t.string   "vote_title"
    t.string   "govtrack_id"
    t.integer  "meeting_id"
    t.string   "question_type"
    t.integer  "voteable_id"
    t.boolean  "tweeted",       :default => false
  end

  create_table "meetings", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "ordinal"
    t.string   "majority_party"
    t.string   "party_of_president"
    t.string   "years"
    t.integer  "total_votes"
    t.integer  "total_cloture_votes"
  end

  create_table "senators", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "govtrack_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "party"
    t.text     "meta"
    t.string   "state"
    t.boolean  "in_office"
  end

  create_table "voteable", :force => true do |t|
    t.string   "name"
    t.string   "govtrack_id"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "voteables", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_id"
    t.string   "name"
    t.string   "govtrack_id"
    t.string   "type"
  end

end
