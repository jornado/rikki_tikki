class Block
  include DataMapper::Resource
  
  property :id, Serial, :index => true
  property :started_at, DateTime
  property :ended_at, DateTime
  property :created_at, DateTime, :index => true
  property :updated_at, DateTime
  
  belongs_to :project
  
  def get_delta
    get_time_delta(self.started_at, self.ended_at)
  end
  
  def round(minutes)
    rounded_minutes = minutes - (minutes % 15)
    puts "Orig: #{minutes} Rounded: #{rounded_minutes}" if confit.app.debug
    rounded_minutes
    
    case rounded_minutes
      
    when 0..15.9999
      15
    when 15.99999..30.9999
      30
    when 30.99999..45.9999
      45
    when 45.99999..60
      60
    end
    
  end
  
end