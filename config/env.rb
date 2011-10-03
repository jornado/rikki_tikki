require "rubygems"
require "bundler"
Bundler.setup
Bundler.require :default

module Sinatra
    class Base

      configure do
        
        set :root, File.join(File.expand_path(File.join(File.dirname(__FILE__))), '..')
        set :public, File.join(root, 'public')
        set :static, true
        set :raise_errors, true

        TIMEZONE = 'US/Pacific'
        ENV['TZ'] = TIMEZONE

        confit File.join(root, 'config', 'app.yml'), environment.to_s
        Dir.glob(File.join(root, 'lib', '**/*.rb')).each { |f| require f }
        Dir.glob(File.join(root, 'models', '**/*.rb')).each { |f| require f }

        use Rack::Session::Cookie, :key => 'app.session',
                                   :path => '/',
                                   :expire_after => 2592000,
                                   :secret => 'yaddar45u930fjyadda'
        register ::Sinatra::Flash

        not_found do
          erb :_404, :layout => false
        end

        require File.join(root, 'app')
        require File.join(root, 'helpers')

        helpers Helpers
        DataMapper.finalize
        DataMapper::Logger.new(STDOUT, :debug) if confit.app.debug
        DataMapper.setup :default, YAML.load_file(File.join(root, 'config', 'database.yml'))[environment.to_s]
        
      end


    end

end

puts "Rikki Tikki started at #{Time.now}"