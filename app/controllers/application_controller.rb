require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :sessions_secret, "badbeta"
    register Sinatra::Flash
  end

  get "/" do
    if logged_in?
      erb :'/users/home'
    else
      erb :index
    end
  end
  
  helpers do
    def login(username, password)
      session[:username] = username
      @user = User.find_by(username: params[:username])
      if @user && @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect "/home"
      else
        redirect "/login"
      end
    end
    
    def logged_in?
      !!session[:user_id]
    end 
    
    def current_user
      User.find_by_id(session[:user_id])
    end
  end
  
end