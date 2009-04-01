require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'activesupport'

MEETING_OF_CONGRESS = 102

VOTES_URL = "http://www.govtrack.us/data/us/#{MEETING_OF_CONGRESS}/votes.all.index.xml"
ROLL_URL = "http://www.govtrack.us/congress/vote.xpd?vote=%s"
ISGD_URL = "http://is.gd/api.php?longurl=#{ROLL_URL}"

GOVTRACK_URL = "http://www.govtrack.us/congress/vote.xpd?vote=%s"


if RUBY_PLATFORM =~ /darwin/
  TMP_DATE = "/Users/Andrew/Code/last-roll"
else
  TMP_DATE = "/home/andrew/scripts/last-roll"
end

SITE_PATH = "/Users/andrew/Desktop/www.govtrack.us/data/us/#{MEETING_OF_CONGRESS}"


def get_vote_info(vote, has_bill)
  puts "Getting info for #{vote.govtrack_id}..."
  
  puts GOVTRACK_URL % vote.govtrack_id
  
  doc = Hpricot( open(GOVTRACK_URL % vote.govtrack_id) )
  
  if (has_bill)
    bill_title = (doc / "//table/tr[3]/td[2]/div/table/tr[4]/td[2]/a")[0].inner_text
    vote.shorthand = bill_title.split(':').first.strip
    bill_title = bill_title.gsub(vote.shorthand, '').strip
    bill_title = bill_title.gsub(/^:/, '').strip
    vote.bill_title = bill_title
  end
  
  
  puts "Cloture on #{vote.shorthand}: #{vote.bill_title}"
  
  breakdown_xpath = {
    :d_ayes => "//table/tr[3]/td[2]/div/table[2]/tr[2]/td[5]",
    :r_ayes => "//table/tr[3]/td[2]/div/table[2]/tr[2]/td[6]",
    :i_ayes => "//table/tr[3]/td[2]/div/table[2]/tr[2]/td[7]",
    :d_nays => "//table/tr[3]/td[2]/div/table[2]/tr[3]/td[5]",
    :r_nays => "//table/tr[3]/td[2]/div/table[2]/tr[3]/td[6]",
    :i_nays => "//table/tr[3]/td[2]/div/table[2]/tr[3]/td[7]"
  }
  
  breakdown = {}
  
  breakdown_xpath.each do |key, xpath|
    breakdown[key] = (doc / xpath).inner_text.to_i
  end
  
  vote.d_ayes = breakdown[:d_ayes] + breakdown[:i_ayes]
  vote.r_ayes = breakdown[:r_ayes]
  vote.d_nays = breakdown[:d_nays] + breakdown[:i_nays]
  vote.r_nays = breakdown[:r_nays]
  
  vote
end


puts SITE_PATH


Dir.foreach("#{SITE_PATH}/rolls/") do |file|
  next unless file =~ /\.xml$/
  
  xml = Hpricot( File.open("#{SITE_PATH}/rolls/#{file}") )
  
  vote_name = (xml / "//question")[0].inner_text
  
  next unless vote_name.downcase.include?("cloture")
  
  roll = (xml / "/roll")[0]  
  
  has_bill = !((xml / "bill")[0].nil?)
  
  year = roll["year"]
  roll = roll["roll"]
  
  id = "s#{year}-#{roll}"
  
  next if ClotureVote.find_by_govtrack_id(id)
  
  cloture_vote = ClotureVote.new
  cloture_vote.meeting = Meeting.find_by_ordinal(MEETING_OF_CONGRESS)
  cloture_vote.govtrack_id = id
  
  
  cloture_vote.date_of_vote = Time.zone.at(roll["when"].to_i)
  
  cloture_vote.vote_title = vote_name
  cloture_vote.ayes = roll["aye"].to_i
  cloture_vote.nays = roll["nay"].to_i

  get_vote_info(cloture_vote, has_bill)
  
  if (!has_bill)
    cloture_vote.bill_title = (xml / "question")[0].inner_text
  end
  
  cloture_vote.save!

  if (has_bill)
    puts "Saved #{cloture_vote.shorthand}!"
  else
    puts "Saved vote!"
  end
  
  # Pause in between requests so that GovTrack doesn't hate us.
  sleep 1
end




