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

  post '/signup' do
    if User.all.find {|user| user.username == params[:username]}
      flash[:username_message] = "Username already taken"
      redirect '/signup'
    elsif User.all.find {|user| user.email == params[:email]}
      flash[:email_message] = "Email already registered"
      redirect '/signup'
    end
    @user = User.new(params)
    if @user.valid?
      @user.save
      session[:user_id] = @user.id
      redirect "/users/#{@user.slug}"
    end
  end

end
