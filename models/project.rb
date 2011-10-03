class Project
  include DataMapper::Resource
  
  property :id, Serial, :index => true
  property :name, String, :required => true, :index => true, :length => 100
  property :jobcode, String, :required => false, :length => 100
  property :created_at, DateTime, :index => true
  property :updated_at, DateTime
  
  has n, :blocks
  
end