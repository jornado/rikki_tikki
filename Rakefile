require 'rubygems'
require File.join('.', 'config', 'env.rb')

namespace :db do

  desc "Init db"
  task :bootstrap do
    puts "Bootstrapping database."
    DataMapper.auto_migrate!
  end
  
end