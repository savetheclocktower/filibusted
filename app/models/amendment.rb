class Amendment < Voteable

  # Meh, I don't get this join for free
  def bill
    Bill.find(bill_id)
  end
  
  def bill=(bill)
    self.bill_id = bill.id
  end
end
