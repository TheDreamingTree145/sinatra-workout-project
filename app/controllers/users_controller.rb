require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

  get '/signup' do
    if logged_in?
      @user = current_user
      redirect "/users/#{@user.slug}"
    else
      erb :'/users/create_user'
    end
  end

  get '/users/:slug' do
    if logged_in?
      @user = current_user
      if @user = User.find_by_slug(params[:slug])
        erb :'/users/show'
      else
        flash[:login_mesage] = "You must be logged in to view your user page"
        redirect '/login'
      end
    else
      flash[:login_mesage] = "You must be logged in to view your user page"
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

    erb :'/users/login'
  end

  post '/signup' do
    if User.all.find {|user| user.username == params[:username]}
      flash[:username_message] = "Username already taken. If you already have an account please go to the login page."
      redirect '/signup'
    elsif User.all.find {|user| user.email == params[:email]}
      flash[:email_message] = "Email already registered. If you already have an account please go to the login page."
      redirect '/signup'
    end
    @user = User.new(params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    else
      flash[:valid_message] = "Please make sure all fields are filled out"
      redirect '/signup'
    end
  end

end
