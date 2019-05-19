class ClimbsController < ApplicationController
  
  get '/home' do
    if logged_in? && current_user
      @user = current_user
      session[:user_id] = @user.id
      @climbs = @user.all
      erb :'/users/home'
    else
      redirect :'/login'
    end
  end
  
  get '/climbs/new' do
    if logged_in? && current_user
      @user = current_user
      session[:user_id] = @user.id
      erb :'/climbs/new'
    elses
      flash[:error] = "ERROR: Please log in to do that!"
      redirect '/login'
    end
  end
  
  post '/climbs' do
    @user = User.find_by_id(session[:id])
    if logged_in? 
      @climb = Climb.create(params)
      @climb.users_id = @user.id
      @climb.save
      erb :"/climbs/#{@climb.id}"
    else
      flash[:error] = "ERROR: Please try again."
      redirect '/climbs/new'
    end
  end
   
  get '/climbs/:id' do
    if logged_in?
      @climb = Climb.find_by_id(params[:id])
      erb :'climbs/show'
    else
      redirect '/login'
    end
  end
   
  get '/climbs/:id/edit' do 
    @user = User.find_by_id(session[:id])
    @climb = Climb.find_by_id(params[:id])
    if @user.id == @climb.users_id
      erb :'/climbs/edit'
    else
      redirect '/users/failure'
    end
  end
   
  patch '/climbs/:id' do
    @climb = Climb.find_by_id(params[:id])
    @climb.name = params[:name]
    @climb.content = params[:content]
    @climb.save
    erb :"/climbs/#{@climb.id}"
  end
   
  delete '/climbs/:id' do
    @climb = Climb.find_by_id(params[:id])
    @climb.delete
    redirect '/users/home'
  end
  
end