# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  
  def him(senator)
    return "her" if senator.meta[:gender] == "F"
    "him"
  end
  
  def he(senator)
    return "she" if senator.meta[:gender] == "F"
    "he"
  end
  
  def his(senator)
    return "her" if senator.meta[:gender] == "F"
    "his"
  end
  
  def link_to_senator(senator)
    link_to(
      senator.formatted_name,
      url_for_senator(senator),
      { 
        :class => "senator-#{senator.party.downcase}"
      }
    )
  end
  
  def url_for_senator(senator)
    url_for(
    {
      :controller => :senators, :action => :show, 
      :params => { :id => senator.govtrack_id }
    }    
    )
  end
  
  def link_to_cloture_vote(vote)
    link_to "##{vote.roll_call}", 
     :controller => :votes, :action => :show,
     :params => { :id => vote.govtrack_id }
  end
  
  def link_to_voteable(voteable)
    html = ""
    
    if (voteable.is_a? Amendment)
      html << "Amendment to "
      name = voteable.bill.name
    else
      name = voteable.name
    end
    
    html << link_to(name, voteable_url(voteable))
  end
  
  def link_to_amendment(amendment)
    link_to amendment.name, voteable_url(amendment)
  end
  
  def voteable_url(voteable)
    id = voteable.govtrack_id
    if voteable.is_a? Amendment
      return "http://www.govtrack.us/congress/amendment.xpd?session=111&amdt=#{id}"
    end
    
    if voteable.is_a? Bill
      return "http://www.govtrack.us/congress/bill.xpd?bill=#{id}"
    end
    
    "?"
  end
  
  def govtrack_vote_url(vote)
    "http://www.govtrack.us/congress/vote.xpd?vote=#{vote.govtrack_id}"
  end
  
  def format_cast_vote(vote)
    if vote.vote
      return "<span class='green'>Aye</span>" 
    else
      return "<span class='red'>Nay</span>"
    end
  end
  
  def format_cloture_vote_outcome(vote)
    if (vote.passed?)
      return "<span class='green'>Passed</span>" 
    else
      return "<span class='red'>Failed</span>"      
    end
  end
    
  def obstruction_rate_class_names(senator)
    keyword = keyword_for_obstruction_rate(senator.obstruction_rate)
    "obstruction-rate #{keyword}"    
  end
  
  def keyword_for_obstruction_rate(obstruction_rate)
    obstruction_rate /= 100 if obstruction_rate > 1
    
    return "red"   if obstruction_rate >= 0.7
    return "green" if obstruction_rate <= 0.3
    return "yellow"    
  end
  
end
