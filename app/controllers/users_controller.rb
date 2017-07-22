class UsersController < ApplicationController

  get '/signup' do
    if logged_in?
      @user = current_user
      redirect "/users/#{@user.slug}"
    else
      erb :'/users/create_user'
    end
  end



end
