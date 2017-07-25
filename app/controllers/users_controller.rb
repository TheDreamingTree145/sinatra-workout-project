require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if logged_in?
      @user = current_user
      session[:message] = "You're already logged in!"
      redirect "/users/#{@user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  get '/users' do
    redirect '/login'
  end

  get '/users/:slug' do
    if logged_in?
      @user = current_user
      if @user = User.find_by_slug(params[:slug])
        erb :'/users/show'
      else
        session[:message] = "You must be logged in to view your user page"
        redirect '/login'
      end
    else
      session[:message] = "You must be logged in to view your user page"
      redirect '/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.destroy
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/login' do
    if logged_in?
      @user = current_user
      flash[:message] = "You're already logged in!"
      redirect "/users/#{@user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/signup' do
    if User.all.find {|user| user.username == params[:username]}
      session[:message] = "Username already taken. If you already have an account please go to the login page."
      redirect '/signup'
    elsif User.all.find {|user| user.email == params[:email]}
      session[:message] = "Email already registered. If you already have an account please go to the login page."
      redirect '/signup'
    end
    @user = User.new(params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    else
      session[:message] = "Please make sure all fields are filled out"
      redirect '/signup'
    end
  end

  post '/login' do
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    else
      session[:message] = "Your username and/or password are incorrect"
      redirect '/login'
    end
  end

  post '/users/workouts/:slug/remove' do #Restfullnes
    @user = current_user
    @workout = Workout.find_by_slug(params[:slug])
    @user.workouts.delete(@workout)
    session[:message] = "You have removed the workout from your list"
    redirect "/users/#{@user.slug}"
  end

end
