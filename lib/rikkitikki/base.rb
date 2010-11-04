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
    
    def save
      unsaved = @db.get_unsaved
      unsaved.each_with_index do |record, i|
        minutes = self.get_delta(record, unsaved[i+1])
        info "Min #{minutes}"
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

