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
			@date = date
      make_project_list
      #puts "Projects #{@projects.inspect}"
      unsaved = @db.get_unsaved(date)
      
      unsaved.each_with_index do |record, i|
        
        if (i+1) < unsaved.count
          minutes = self.get_delta(record, unsaved[i+1])
          next if minutes < 1
          @projects[record.project.git_name] += minutes
          #puts "Date #{record.created_at} Min #{minutes}"
        end
      
      end
      
			@projects.reject!{|key, value| key =~ /ps \-Af/}
			@projects.reject!{|key, value| key =~ /#{@@MATCH_STRING}/}
			@projects.reject!{|key, value| key.nil?}
			@projects.reject!{|key, value| value==0}
      #@projects.sort.each do |project, time|
      #  puts "#{project}:#{time/60.to_f}"
      #end

			@projects
    end
    
    def go
      #@cli = RikkiTikki::Cli.new(ARGV, STDIN)
      #@cli.run
      
      @git_name = self.grep_process
      puts "Processing #{@git_name}"
      existing = @db.get_or_create_project(@git_name)
      record = @db.insert_record(existing)
    end
  
    def grep_process
      ps_match = ""
			ps = `ps -Af | grep '#{@@MATCH_STRING}'`
			puts "ps (#{ps})"
      ps.chomp!
      lines = ps.split("\n")
      
      lines.each do |line|
        if line !~ /grep/
          ps_match = line
					puts "Found match: #{ps_match}"
        end
      end
      
      ps_match =~ /([^\/]+?)$/
      
      return $1
    end
    
  end
end

