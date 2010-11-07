require 'rubygems'
require 'sinatra_messages'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'
require 'dm-aggregates'

Dir.glob(File.join('.', 'lib', '**/*.rb')).each { |f| require f }

include Sinatra::MessagesHelper

def main
  date = eval(ARGV[0]) if ARGV and ARGV[0]
  puts "Processing for is #{date}"

  rikki = RikkiTikki::Base.new
  

  rikki.save(date)
end

main
