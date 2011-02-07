#require 'config/env'
require "rubygems"
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'dm-validations'
require 'rack-flash'
require 'tickspot'
require 'httparty'
require 'confit'
require 'dm-sqlite-adapter'
require 'sinatra'
require 'sqlite3'

confit('./config/app.yml', 'development', true)
Dir.glob(File.join('.', 'lib', '**/*.rb')).each { |f| require f }

def main
  puts "...Rikki Tikki Timer..."

  while 1 do
    rikki = RikkiTikki::Base.new
    rikki.go
    Kernel.sleep(1*60)
  end
end

main
