module Helpers
  
  def match_date(date)
    date ? (eval(date) if date =~ /Date\.[-a-z0-9]+/) : Date.today-1
  end
  
  def linkify_date(date)
    "<a href=\"?date=Date.new(#{date.year}, #{date.mon}, #{date.day})\">#{day_of_week(date.wday)} #{date.mon}/#{date.day}</a>" 
  end
  
end