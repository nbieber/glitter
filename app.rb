require 'sinatra'
require 'sinatra/activerecord'
require './models'

require 'bundler/setup' 
require 'rack-flash'

enable :sessions
use Rack::Flash, :sweep => true

configure :development do
	set :database, "sqlite3:///glitter.sqlite3"
end

configure :production do
 db = URI.parse(ENV['DATABASE_URL'] || 'postgres:///localhost/mydb')

 ActiveRecord::Base.establish_connection(
   :adapter  => db.scheme == 'postgres' ? 'postgresql' : db.scheme,
   :host     => db.host,
   :username => db.user,
   :password => db.password,
   :database => db.path[1..-1],
   :encoding => 'utf8'
 )
end

#set :sessions, true

def current_user
	# if someone is signed in
	if session[:user_id]
		@user = User.find(session[:user_id])
	end
end

get '/' do
	@tweets = Tweet.all
	erb :tweets
end

get '/:username' do
	@page_user = User.find_by_username(params[:username])
	if !@page_user
		redirect '/'
	end
	@tweets = Tweet.where(:user_id => @page_user.id)
	erb :profile
end

get '/users/new' do
	erb :sign_up
end

post '/users/new' do
	user = User.create(params[:user])
	profile = Profile.create(params[:profile])
	profile.user = user
	profile.save

	redirect '/'
end

get '/sessions/new' do
	erb :sign_in
end

post '/sessions/new' do
	# look up user in the database
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id

		# notify the user that they are signed in
		flash[:notice] = "You are signed in! Shiny!"

		redirect '/'
	else
		flash[:error] = "Login failed. Please try again."

		redirect '/sessions/new'
	end
	
end

get '/tweets/new' do
	if current_user
		erb :create_tweet
	else
		redirect '/'
	end
end

post '/tweets/new' do
	Tweet.create(content: params[:content], user_id: current_user.id)
	redirect '/'
end

get '/sessions/clear' do
	session.clear
	redirect '/'
end
