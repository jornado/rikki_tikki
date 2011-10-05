If you are as forgetful as I, you know well that remembering what you've done all day is a major pain in the hiney. So in the spirit of industrious laziness, I wrote an app for that.

## How it works

Rikki Tikki times you times, so you don't have to. It periodically pings your computers running processes, looking for the thin server. When it finds such a process, it makes a note of the directory it's running from, which happens to be the name of a git repository that maps to a project name. Handy! At the end of the day (or week, shhh), you can ask Rikki Tikki what you've been working on. It looks like this:

## How to install it

* Clone the repository located here: https://github.com/poeks/rikki_tikki
* Rename the app.yml.sample and database.yml.sample files. Change the environment to match your own blah_dev.
* Install the Gem bundle:

`bundle install`
* Bootstrap the database:

`bundle exec db:bootstrap RACK_ENV=your_env`
* Make sure your server-running command includes the directory of your project by including the -c flag, for example (from my .profile):

`alias ru='bundle exec thin start -e jo_dev -p 4454 -R config.ru -c ${PWD}'`

## How to use it

* Add an these aliases to your .profile (you don't have to, but it simplifies life, so hey):

`alias rikki_run='cd /path/to/rikki_tikki; /path/to/rikki_tikki/bin/rikki run RACK_ENV=your_env' 
alias rikki_show='cd /path/to/rikki_tikki; /path/to/rikki_tikki/bin/rikki show ${1} RACK_ENV=your_env' `
* Every morning when you boot up your computer, keep this running in terminal…
* When you'd like to know what you've been working on, just ask. Here are some examples:

`rikki_show today RACK_ENV=your_env
rikki_show yesterday RACK_ENV=your_env
rikki_show 'last friday' RACK_ENV=your_env`


Et voila!



