require 'rubygems'
require 'sinatra_messages'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

Dir.glob(File.join('.', 'lib', '**/*.rb')).each { |f| require f }

include Sinatra::MessagesHelper

def main
  rikki = RikkiTikki::Base.new
  rikki.save
end

main
