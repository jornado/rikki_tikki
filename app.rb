require 'rubygems'
require 'sinatra'
require 'sqlite3'
require 'dm-core'
require 'dm-timestamps'
require 'dm-migrations'
require 'lib/models'
require 'lib/stats'
require 'json'

configure :development do
  env = 'development'
  config = YAML.load_file( 'config/craigshist.yml' )
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
  @page_title = "Craigshist"
  @zips = ZipCode.all()
  erb :index, :layout => true
end

get '/show/:id' do
  @listing = Listing.get(params[:id])
  if @listing
    @page_title = "Listing \##{@listing.posting_id}"
    erb :show
  else
    redirect('/list')
  end
end

get '/list' do
  @page_title = "Listings"
  @listings = Listing.all(:price.gte => 1, :order => [:price.asc])
  erb :list
end

get '/ajax/histogram/:zip_code' do
  headers "Content-Type" => "text/plain; charset=utf-8"
    
  @prices = repository(:default).adapter.select("SELECT l.price FROM listings l, zip_codes z where l.zip_code_id = z.id and z.zip_code = #{params[:zip_code]}")
  
  stat = Stats.new
  stat.init
  @vals = stat.histogram(@prices)
  output = {
    'zip' => params[:zip_code],
    'data' => @vals
  }
  output.to_json
end
