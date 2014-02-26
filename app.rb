require 'sinatra'
require 'sinatra/activerecord'
require './models'

# require 'bundler/setup' 
# require 'rack-flash'

# enable :sessions
# use Rack::Flash, :sweep => true

set :database, "sqlite3:///flittr.sqlite3"
set :sessions, true

get '/' do
	@tweets = Tweet.all
	erb :home
end

get '/:username' do
	@page_user = User.find_by_username(params[:username])
	if !@page_user
		redirect '/'
	end
	@tweets = Tweet.where(:user_id => @page_user.id)
	erb :home
end

get '/users/new' do
	erb :sign_up
end

post '/users/new' do
	user = User.create(username: params[:username], password: params[:password])
	Profile.create(fullname: params[:fullname], email: params[:email], user_id: user.id)
	redirect '/'
end