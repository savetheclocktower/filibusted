class CongressController < ApplicationController

  def index
    @meeting = Meeting.find_by_ordinal(111)
  end
  
end
