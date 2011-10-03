Rikki Tikki expects you to be running your server sorta like this:

ruby /Users/poeks/.rvm/gems/ruby-1.9.2-p180/bin/thin start -e dev -p 1234 -R config.ru -c /Users/poeks/work/rikki_tikki

The important bits are "thin" and the "-c [dir]" option.

To run it: bin/rikki run