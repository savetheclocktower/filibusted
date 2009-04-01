module VotesHelper
  
  def opencongress_url(vote)
    shorthand = vote.shorthand
    shorthand = shorthand.downcase.gsub('.', '').gsub(/\s/, '')
    
    shorthand = shorthand.gsub("hr", "h")
    
    "http://opencongress.org/bill/#{vote.meeting.ordinal}-#{shorthand}/show"
  end
  
  def govtrack_url(vote)
    shorthand = vote.shorthand
    shorthand = shorthand.downcase.gsub('.', '').gsub(/\s/, '')
    
    code = shorthand.gsub(/\d/, '')
    number = shorthand.gsub(/\D/, '')

    "http://www.govtrack.us/congress/bill.xpd?bill=#{code}" +   
     "#{vote.meeting.ordinal}-#{number}"
  end
  
  def breakdown_of_nay_voters(vote)
    str = []
    
    str << pluralize(vote.r_nays, "Republican") if vote.r_nays > 0
    str << pluralize(vote.d_nays, "Democrat")   if vote.d_nays > 0
    
    str.join(" and ")
  end
  
end
