require File.join('.', 'config', 'env.rb')

def main
  puts "...Rikki Tikki Timer..."

  while 1 do
    rikki = RikkiTikki::Base.new
    rikki.go
    Kernel.sleep(1*60)
  end
end

main
