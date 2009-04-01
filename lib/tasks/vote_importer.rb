require 'rubygems'
require 'hpricot'
require 'open-uri'
require 'activesupport'

GOVTRACK_SENATOR_URL = "http://www.govtrack.us/congress/person.xpd?id=%s"

module VoteImporter
  def self.get_vote_info(vote)
    puts "Getting info for #{vote.shorthand}..."

    doc = Hpricot( open(GOVTRACK_URL % vote.govtrack_id) )
    
    vote_table = (doc / ".maincontent table")[1]
    
    # Find the row with the "Yea" count
    yea_row = (vote_table / "//tr/td[1]").find { |td| td.inner_text.include? "Yea"}.parent
     
    nay_row = (vote_table / "//tr/td[1]").find { |td| td.inner_text.include? "Nay"}.parent
    
    breakdown_xpath = {
      :d => "//td[5]",
      :r => "//td[6]",
      :i => "//td[7]"
    }
    
    breakdown = {}
    
    %w{d_ayes r_ayes i_ayes d_nays r_nays i_nays}.each do |key|
      party = key[0..0]
      xpath = breakdown_xpath[party.to_sym]
      row = key.include?("ayes") ? yea_row : nay_row
      breakdown[key.to_sym] = (row / xpath).inner_text.to_i
    end
    

    vote.d_ayes = breakdown[:d_ayes] + breakdown[:i_ayes]
    vote.r_ayes = breakdown[:r_ayes]
    vote.d_nays = breakdown[:d_nays] + breakdown[:i_nays]
    vote.r_nays = breakdown[:r_nays]
    
    # Iterate through the votes table and keep track
    # of which senator voted for what.
    
    rows_aye = (doc / "tr.VoteAye")
    rows_nay = (doc / "tr.VoteNay")
    
    [rows_aye, rows_nay].each_with_index do |rows, index|
      voted_aye = (index == 0)
      rows.each do |row|
        a = row.at('a')
        id = a['href'].split('=').last  
        name = a.inner_text.gsub(/\[[DR]\]/, '').strip
        senator = get_senator(id, name)
        
        cast_vote = CastVote.create(
          :senator_id      => senator.id,
          :cloture_vote_id => vote.id,
          :vote            => voted_aye
        )
      end
    end

    vote
  end
  
  # Finds or creates the senator based on information from GovTrack.
  def self.get_senator(id, name)
    senator = Senator.find_by_govtrack_id(id)
    
    if senator.nil?
      
      response = Sunlight::Legislator.all_where(:govtrack_id => id)
      
      if response.size == 0
        # Gah. Do some fuzzy matching with the name instead
        response = Sunlight::Legislator.search_by_name(name)
        
        if response.nil?
          last_name, first_name = name.split(", ")
          return Senator.find_or_create_by_first_name_and_last_name(
            :first_name => first_name, :last_name => last_name)
        end
        #raise "Couldn't find legislator with govtrack_id: #{id}!"
      end
      
      sen = response[0]
      
      first_name = sen.nickname.empty? ? sen.firstname : sen.nickname
      
      senator = Senator.create(
        :first_name  => first_name,
        :last_name   => sen.lastname,
        :govtrack_id => id
      )
      
      puts "Created and saved #{senator.first_name} #{senator.last_name}"
    end
    
    senator
  end
  
end
