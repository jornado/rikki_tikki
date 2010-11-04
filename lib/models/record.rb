class Record
  include DataMapper::Resource

  property :id, Serial
  property :is_saved, Boolean, :required => true, :default => 'f'
  property :created_at, DateTime
  
  belongs_to :project
  
end
