require File.join('.', 'config', 'env.rb')
STDOUT.reopen(LOG) if defined?(LOG)

map '/' do
  run App
end