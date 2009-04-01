meetings = [
  [101, "1989-1991", "D", "R"],
  [102, "1991-1993", "D", "R"],
  [103, "1993-1995", "D", "D"],
  [104, "1995-1997", "R", "D"],
  [105, "1997-1999", "R", "D"],
  [106, "1999-2001", "R", "D"],
  [107, "2001-2003", "D", "R"],
  [108, "2003-2005", "R", "R"],
  [109, "2005-2007", "R", "R"],
  [110, "2007-2009", "D", "R"],
  [111, "2009-2011", "D", "D"]
]

meetings.each do |m|
  
  meeting = Meeting.new
  meeting.ordinal = m[0]
  meeting.years = m[1]
  meeting.majority_party = m[2]
  meeting.party_of_president = m[3]
  
  meeting.save!
end