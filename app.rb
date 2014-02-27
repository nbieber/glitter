require 'sinatra'
require 'sinatra/activerecord'
require './models'

# require 'bundler/setup' 
# require 'rack-flash'

# enable :sessions
# use Rack::Flash, :sweep => true

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

set :sessions, true

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
	user = User.create(username: params[:username], password: params[:password])
	Profile.create(fullname: params[:fullname], email: params[:email], user_id: user.id)
	redirect '/'
end