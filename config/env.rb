require "rubygems"
require "bundler"
Bundler.setup
Bundler.require :default

TIMEZONE = 'US/Pacific'
ENV['TZ'] = TIMEZONE

confit File.join('.', 'config', 'app.yml'), ENV['RACK_ENV']
Dir.glob(File.join('.', 'lib', '**/*.rb')).each { |f| require f }
Dir.glob(File.join('.', 'models', '**/*.rb')).each { |f| require f }

require File.join('.', 'helpers')
include Helpers

DataMapper.finalize
DataMapper::Logger.new(STDOUT, :debug) if confit.app.debug
DataMapper.setup :default, YAML.load_file(File.join('.', 'config', 'database.yml'))[ENV['RACK_ENV']]
