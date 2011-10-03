require 'rubygems'

namespace :db do

  desc "bootstrap db"
  task :bootstrap do
    require File.join('.', 'config', 'env.rb')
    DataMapper.auto_migrate!
  end

end
