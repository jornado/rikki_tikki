module Helpers
  def match_date(date)
    date ? (eval(date) if date =~ /Date\.[-a-z0-9]+/) : Date.today-1
  end
end