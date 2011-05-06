require "rubygems"
require "bundler"
Bundler.setup
Bundler.require :default

Sinatra::Base.set :root, File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..')

confit File.join(Sinatra::Base.root, 'config', 'app.yml')
DataMapper::Logger.new($stdout, :debug)
DataMapper::setup(:default, "sqlite3:#{confit.app.database}")

Dir.glob(File.join(Sinatra::Base.root, 'lib', '**/*.rb')).each { |f| require f }   
Dir.glob(File.join(Sinatra::Base.root, 'models', '**/*.rb')).each { |f| require f }

require File.join(Sinatra::Base.root, 'app')
#require File.join(Sinatra::Base.root, 'rikki')
require File.join(Sinatra::Base.root, 'helpers')

Sinatra::Base.enable :sessions
Sinatra::Base.use Rack::Session::Cookie
Sinatra::Base.use Rack::Flash
Sinatra::Base.helpers Helpers

