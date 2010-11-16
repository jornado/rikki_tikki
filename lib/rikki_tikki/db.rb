module RikkiTikki
  
  class Db
    
    def initialize(start_time="08:30:00", stop_time="18:30:00")
      #DataMapper::Logger.new($stdout, :debug)
		  #DataMapper::setup(:default, "sqlite3:#{confit.database}")    
      #DataMapper.auto_upgrade!
      @start_time = start_time
      @stop_time = stop_time
    end
    
    def get_unsaved(date)
      start = "#{date.year}-#{date.month}-#{date.day} #{@start_time}"
      stop = "#{date.year}-#{date.month}-#{date.day} #{@stop_time}"
      
      Record.all(:is_saved => 0, :created_at.gte => start, :created_at.lte => stop)
    end
    
    def get_or_create_project(project)
      existing = Project.first(:git_name => project)
      if existing
        info "#{project} exists!"
        return existing
      else
        info "New project! #{project}"
        return Project.create(:git_name => project)
      end
    end
    
    def insert_record(project)
      record = Record.new
      record.project = project
      record.save
      record
    end
    
  end
  
end