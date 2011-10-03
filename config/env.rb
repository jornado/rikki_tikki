require "rubygems"
require "bundler"
Bundler.setup
Bundler.require :default

TIMEZONE = 'US/Pacific'
ENV['TZ'] = TIMEZONE

root = '.'
confit File.join(root, 'config', 'app.yml'), ENV['RACK_ENV']
Dir.glob(File.join(root, 'lib', '**/*.rb')).each { |f| require f }
Dir.glob(File.join(root, 'models', '**/*.rb')).each { |f| require f }

DataMapper.finalize
DataMapper::Logger.new(STDOUT, :debug) if confit.app.debug
DataMapper.setup :default, YAML.load_file(File.join(root, 'config', 'database.yml'))[ENV['RACK_ENV']]
        
puts "Rikki Tikki started at #{Time.now}"