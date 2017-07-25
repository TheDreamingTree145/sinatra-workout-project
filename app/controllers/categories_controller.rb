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

  get 'categories/exercises/slug' do #restfullness
    if logged_in?
      @user = current_user
      erb :'/categories/show_exercises'
    else
      flash[:message] = "Please login to view this page"
      redirect '/login'
    end
  end

end
