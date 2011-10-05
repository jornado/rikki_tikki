class Rikki
  
  attr_accessor :current_project, :previous_project, :current_project_obj, :debug
  
  def initialize(debug)
    self.debug = debug
  end
  
  def run
    log "Hello, I am Rikki Tikki, and I am timing your times...\n", 'good'
    
    while 1 do
      log "Timing... #{Time.now}", 'debug'
      
      `ps -Af | grep 'thin'`.split("\n").each do |line|
        
        if line =~ /ruby.+thin.+\-c ([^\s]+)/
          self.current_project = get_project($1)
          next if $1 =~ /#{confit.app.app_dir}/
          process
        else
          next if line =~ /grep '?thin/
          log "No server running #{line}", "bad"
        end
        
      end
      
      self.previous_project = self.current_project
      sleep delay
    end
    
  end
  
  def show(day)
    log "Hours\n----", 'good'
    
    day = Chronic.parse("#{day}").to_date
    next_day = day + 1
    previous_day = day + 1
    
    first_block = Block.first(:started_at.lt => next_day, :started_at.gte => day, :order => :started_at.asc)
    last_block = Block.first(:started_at.lt => next_day, :started_at.gte => day, :order => :started_at.desc)
    
    Project.all.each do |project|
      
      project_minutes = 0
      project.blocks(:ended_at.lte => next_day, :started_at.gte => day).each do |block|
        
        project_minutes += block.get_delta
        
      end
      log "#{project.name}\t\t#{in_hours(project_minutes)}" if project_minutes > 0
      
    end
    
    puts ""
    puts "Started #{first_block.started_at.strftime('at %I:%M%p')}".green unless not first_block
    puts "Ended #{last_block.ended_at.strftime('at %I:%M%p')}".green unless not last_block
    puts "#{in_hours get_time_delta(first_block.started_at, last_block.ended_at)} hours for #{day}".green
  end
  
  
  
  private
  
  def in_hours(minutes)
    minutes
    minutes/60.to_f
    sprintf("%2f", minutes/60.to_f)
  end
  
  def log(msg, kind='neutral')
    
    case kind
    when "good"
      puts msg.green
    when "bad"
      puts msg.red
    when "debug"
      puts msg.yellow if self.debug
    else
      puts msg.yellow
    end
    
  end
  
  def delay
    eval confit.app.delay
  end
  
  def get_project(dir)
    dir =~ /([^\/]+)$/
    $1
  end
  
  def process
    log "Switched to #{self.current_project}", "good" if self.current_project != self.previous_project
    self.current_project_obj = Project.first_or_create(:name => self.current_project)
    block = Block.create(:started_at => Time.now, :ended_at => (Time.now + delay), :project => self.current_project_obj)
  end
  
end
