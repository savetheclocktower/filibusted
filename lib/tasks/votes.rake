require File.dirname(__FILE__) + '/vote_importer'

MEETING_OF_CONGRESS = ENV['MEETING'] || 111

VOTES_URL = "http://www.govtrack.us/data/us/#{MEETING_OF_CONGRESS}/votes.all.index.xml"
ROLL_URL = "http://www.govtrack.us/congress/vote.xpd?vote=%s"
ISGD_URL = "http://is.gd/api.php?longurl=#{ROLL_URL}"

GOVTRACK_URL = "http://www.govtrack.us/congress/vote.xpd?vote=%s"

def tweet_text(vote)
  url = IsGd.url("http://filibusted.us/votes/show/#{vote.govtrack_id}")

  text = "Filibuster on #{vote.shorthand} (%) #{vote.passed? ? 'FAILED' : 'SUCCEEDED'}! (#{vote.ayes}↑ #{vote.nays}↓) #{url}"  

  space = 140 - text.size
  
  text.gsub!("%", truncate(vote.bill_title, space))
end

def truncate(text, size)
  return text if text.size <= size  
  text.slice(0, size - 1) + '…'
end

namespace :votes do
  
  desc "Tweets the new cloture votes"
  task (:tweet => :environment) do
    require 'twitter'
    
    cloture_votes = ClotureVote.find(:all, :conditions => { :tweeted => false })

    puts "Found #{cloture_votes.size} new votes."

    unless (cloture_votes.empty?)
      twitter = Twitter::Base.new(ENV['TWITTER_USER'], ENV['TWITTER_PASS'])
      
      cloture_votes.each do |vote|
        text = tweet_text(vote)
        puts "* #{text}"
        next if ENV['DRY_RUN']
        begin
          twitter.update(text)
          vote.tweeted = true
        rescue
          vote.tweeted = false
        end
      end
    end
    
  end
  
  desc "Import the most recent votes from GovTrack"
  task (:update => :environment) do    
      puts "Requesting #{VOTES_URL} ..."

      doc = Hpricot( open(VOTES_URL) )

      Time.zone = "Eastern Time (US & Canada)"
      rolls = []

      #last_date = Time.zone.at(File.read(TMP_DATE).to_i)

      votes = (doc / "//vote[@where='senate']")

      meeting_of_congress = Meeting.find_by_ordinal(MEETING_OF_CONGRESS)
      meeting_of_congress.total_votes = votes.size
      meeting_of_congress.save!

      votes.reverse.each do |vote|
        date = Time.zone.at(vote.attributes['date'].to_i)
        roll = vote.attributes['roll']

        #next unless date > last_date

        attrs = vote.attributes

        id = attrs['id']
        title = attrs['title']
        bill_title = attrs['bill_title']
        count = attrs['counts']

        next unless title && title.downcase.include?("cloture")

        next unless bill_title

        if (ClotureVote.find_by_govtrack_id(id))
          puts "This vote is already in the DB! Skipping..."
          next
        end

        cloture_vote = ClotureVote.new  
        cloture_vote.meeting = meeting_of_congress

        cloture_vote.date_of_vote = date
        cloture_vote.vote_title   = attrs['title']
        cloture_vote.govtrack_id  = id
        
        cloture_vote.shorthand = bill_title.split(':').first.strip
        bill_title = bill_title.gsub(cloture_vote.shorthand, '').strip
        bill_title = bill_title.gsub(/^:/, '').strip
        cloture_vote.bill_title = bill_title
        
        
        # Is the associated bill already in the DB?
        bill = Bill.find_by_govtrack_id(attrs['bill'])

        # If not, create it.
        unless bill
          bill = Bill.create(
            :govtrack_id => attrs['bill'],
            :name => bill_title
          )
        end
        
        
        # Is the cloture vote related to an amendment?
        if (attrs['amendment'])
          amendment = Amendment.find_by_govtrack_id(attrs['amendment'])
          unless amendment
            amendment = Amendment.create(
              :govtrack_id => attrs['amendment'],
              :name => attrs['amendment_title'],
              :bill_id => bill.id
            )
          end
          cloture_vote.voteable = amendment
        else
          # If there's no amendment, then the vote is regarding
          # the bill itself.
          cloture_vote.voteable = bill
        end

        puts "Cloture on #{cloture_vote.shorthand}: #{cloture_vote.bill_title}"

        # 329-86, 24 not voting
        # [yea, nay, not voting]
        counts = count.scan(/([0-9]+)\-([0-9]+)(?:,*\s*([0-9]+))?/)[0]

        if (counts.nil?)
          puts "wtf? #{count}" 
          counts[0]
        end

        next if counts.nil? || counts[0].nil?

        cloture_vote.ayes = counts[0]
        cloture_vote.nays = counts[1]

        puts " #{counts[0]} ayes, #{counts[1]} nays"

        # Save the thing so it has an ID.
        cloture_vote.save!  
        
        # Hate having to do this, but we scrape the page to get the party breakdown.
        # Ain't no other way.
        VoteImporter::get_vote_info(cloture_vote)

        cloture_vote.save!

        #puts counts
        #url = Hpricot(open(ISGD_URL % id))
        puts "Saved #{cloture_vote.shorthand}!"

        # Pause in between requests so that GovTrack doesn't hate us.
        sleep 3
    end    
  end
  
  desc "Removes all votes from the database and re-imports them"
  task :import => [:destroy_all, :update]
  
  desc "Destroy the last-added vote in the database"
  task (:destroy_last => :environment) do
    ClotureVote.find(:last).destroy
  end
  
  desc "Destroy all votes in the database (for the given meeting)"
  task (:destroy_all => :environment) do
    meeting = Meeting.find_by_ordinal(ENV['MEETING'] || 111)
    puts "Erasing votes from meeting #{meeting.ordinal}..."
    
    votes = ClotureVote.find(:all, :conditions => { :meeting_id => meeting.id })
    
    votes.each do |vote|
      vote.voteable.destroy if vote.voteable
      vote.destroy
    end
    
  end
  
end