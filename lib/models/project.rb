class Project
  include DataMapper::Resource

  property :id, Serial 
  property :name, String
  property :git_name, String
  property :tick_id, Integer
  property :created_at, DateTime
  
  has n, :records
  
end
