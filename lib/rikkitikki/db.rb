module RikkiTikki
  
  class Db
    
    def initialize
      DataMapper::Logger.new($stdout, :debug)
      DataMapper.setup(:default, 'sqlite:rikkitikki.db')
      DataMapper.auto_upgrade!
    end
    
    def get_unsaved
      Record.all(:is_saved => 0)
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