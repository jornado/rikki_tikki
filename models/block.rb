class Block
  include DataMapper::Resource
  
  property :id, Serial, :index => true
  property :started_at, DateTime
  property :ended_at, DateTime
  property :created_at, DateTime, :index => true
  property :updated_at, DateTime
  
  belongs_to :project
  
  def get_delta
    delta = self.ended_at - self.started_at
    usec = (delta * 60 * 60 * 24 * (10**6)).to_i
    usec/1_000_000/60
  end
  
end