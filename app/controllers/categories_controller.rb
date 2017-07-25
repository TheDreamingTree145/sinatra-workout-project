require 'rack-flash'

class CategoriesController < ApplicationController
  use Rack::Flash

  get '/categories' do
    if logged_in?
      @user = current_user
      erb :'/categories/categories'
    else
      flash[:message] = "Please login or signup to view categories"
      redirect '/login'
    end
  end

end
