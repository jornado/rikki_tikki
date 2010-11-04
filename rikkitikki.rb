require 'rubygems'
require 'sinatra_messages'
require 'dm-core'
require 'dm-migrations'
require 'dm-timestamps'

Dir.glob(File.join('.', 'lib', '**/*.rb')).each { |f| require f }

include Sinatra::MessagesHelper

def main
  info "...Rikki Tikki Timer..."

  while 1 do
    rikki = RikkiTikki::Base.new
    rikki.go
    Kernel.sleep(5*60)
  end
end

main
