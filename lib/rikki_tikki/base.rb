require 'date'
require 'time'

module RikkiTikki
  class Base
    @@MATCH_STRING = "thin start"
    
    def initialize
      @db = RikkiTikki::Db.new
    end
    
    def get_delta(earlier, later)
      delta = later.created_at - earlier.created_at
      usec = (delta * 60 * 60 * 24 * (10**6)).to_i
      usec/1_000_000/60
    end
    
    def make_project_list
      @projects = Hash.new
      prjs = Project.all
      prjs.each do |prj|
        @projects[prj.git_name] = 0
      end
      @projects
    end
    
    def save(date=Date.today)
      make_project_list
      info "Projects #{@projects.inspect}"
      unsaved = @db.get_unsaved(date)
      
      unsaved.each_with_index do |record, i|
        
        if (i+1) < unsaved.count
          minutes = self.get_delta(record, unsaved[i+1])
          next if minutes < 5
          @projects[record.project.git_name] += minutes
          info "Date #{record.created_at} Min #{minutes}"
        end
      
      end
      
      @projects.sort.each do |project, time|
        info "#{project}:#{time/60.to_f}"
      end

    end
    
    def go
      #@cli = RikkiTikki::Cli.new(ARGV, STDIN)
      #@cli.run
      
      @git_name = self.grep_process
      info "Processing #{@git_name}"
      existing = @db.get_or_create_project(@git_name)
      record = @db.insert_record(existing)
    end
  
    def grep_process
      ps = `ps -Af | grep '#{@@MATCH_STRING}'`
      ps.chomp!
      lines = ps.split("\n")
      
      lines.each do |line|
        if line !~ /grep/
          ps = line
        end
      end
      
      ps =~ /([^\/]+?)$/
      
      return $1
    end
    
  end
end
