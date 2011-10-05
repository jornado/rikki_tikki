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

end