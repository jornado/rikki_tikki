class Project
  include DataMapper::Resource

  property :id, Serial 
  property :name, String
  property :git_name, String
  property :tick_id, Integer, :default => 0
  property :created_at, DateTime
  
  has n, :records
  
  attr_accessor :time
  
  def initialize(*args)
    self.time = 0 if not args and not args[:time]
    super
  end
  
	def namify
		if self.name.nil?
			self.git_name.split(/[-_]/).each{|x| x.capitalize}.join " "
		else
			self.name
		end
	end
	
end
