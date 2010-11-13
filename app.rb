require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'sinatra_messages'
require 'rack'
require 'rack-flash'

Dir.glob(File.join('.', 'lib', '**/*.rb')).each { |f| require f }

include Sinatra::MessagesHelper
use Rack::Session::Cookie
use Rack::Flash

configure :development do
  env = 'development'
  config = YAML.load_file( 'config/app.yml' )
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/#{config[env]['database']}")
  DataMapper.auto_upgrade!
end

# set utf-8 for outgoing
before do
  headers "Content-Type" => "text/html; charset=utf-8"
end

helpers do
  
  def cycle(index)
    if index % 2 == 0
      return 'even'
    else
      return 'odd'
    end
  end
  
  def strip_html(string)
    string.gsub(/<.+?>/, '')
  end
  
  def escape_html(string)
    CGI::escape(string)
  end
  
end

# ROUTES
get '/' do
  redirect '/aggro'
end

get '/aggro' do
	rikki = RikkiTikki::Base.new
	@date = params[:date] ? (eval(params[:date]) if params[:date] =~ /Date\.[-a-z0-9]+/) : Date.today-1
  @projects = rikki.save(@date)
	erb :'aggro'
end

get '/records/show/:id' do
  @listing = Record.get(params[:id])
  if @listing
    erb :show
  else
    redirect('/list')
  end
end

get '/projects/edit/:id' do
	@project = Project.get(params[:id])
	erb :'projects/edit'
end

post '/projects/destroy' do
	@project = Project.get(params[:id])
	@project.records.each do |record|
		record.destroy!
	end
	flash[:notice] = "#{@project.git_name} has been deleted"
	@project.save!
	@project.destroy!
	
	redirect('/projects')
end

get '/projects' do
  @projects = Project.all()
  erb :'projects/list'
end

get '/records' do
  @records = Record.all()
  erb :'records/list'
end
