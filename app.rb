class App < Sinatra::Base

  before do
    puts params.inspect
  end

  WEEKDAYS = %w{Sunday Monday Tuesday Wednesday Thursday Friday Saturday} 

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

    def day_of_week(idx)
      WEEKDAYS[idx]
    end

  end

  # ROUTES
  get '/' do
    redirect '/aggro'
  end

  get '/aggro' do
    @rikki = RikkiTikki::Base.new
  	@date = match_date(params[:date])
    @projects = @rikki.save(@date)
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

  post '/records/destroy' do
  	@record = Record.get(params[:id])
  	@record.destroy!
  	flash[:notice] = "Record has been deleted"

  	redirect('/records')
  end

  post '/projects/update' do
  	@project = Project.get(params[:id])
  	@project.update!(params[:project])
  	@project.save!
  	puts @project.public_methods.sort
  	if @project.valid?
  		redirect("/projects")
  	else
  		flash[:error] = "Please correct the following errors: #{@project.errors.inspect}"
  		erb :'projects/edit'
  	end
  end

  get '/projects' do
    @projects = Project.all()
    erb :'projects/list'
  end

  get '/records' do
    @records = Record.all()
    erb :'records/list'
  end
  
end