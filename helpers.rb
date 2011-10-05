module Helpers
  
  def get_time_delta(start_time, end_time)
    delta = end_time - start_time
    usec = (delta * 60 * 60 * 24 * (10**6)).to_i
    res = usec/1_000_000/60
    #round(res)
  end
  
end