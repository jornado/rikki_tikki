class Aggro
  include DataMapper::Resource

  property :id, Serial
  property :created_at, DateTime
  
  belongs_to :project
  
end
