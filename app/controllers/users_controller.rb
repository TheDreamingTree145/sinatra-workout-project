# require 'rack-flash'
require './lib/slug_module.rb'
class UsersController < ApplicationController
  # use Rack::Flash

  get '/signup' do
    if logged_in?
      session[:message] = "You're already logged in!"
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  get '/users' do
    redirect '/login'
  end

  get '/users/:slug' do
    if logged_in?
      current_user #MAKING ME CALL SELF or current_user is nil??? Allows people to view other peoples show page
      binding.pry
      if current_user = User.find_by_slug(params[:slug])
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
      session[:message] = "You're already logged in!"
      redirect "/users/#{current_user.slug}"
    else
      erb :'/users/login'
    end
  end

  post '/signup' do
    @user = User.new(params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect "/users/#{current_user.slug}"
    else
      @errors = @user.errors.full_messages.join(', ')
      erb :'/users/create_user'
    end
  end

  post '/login' do #errors for nilclass
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect "/users/#{current_user.slug}"
    else
      session[:message] = "Your username and/or password are incorrect"
      redirect '/login'
    end
  end

  post '/users/:slug/remove' do #Restfullnes
    current_user.workouts.delete(current_workout)
    session[:message] = "You have removed the workout from your list"
    redirect "/users/#{current_user.slug}"
  end

end
