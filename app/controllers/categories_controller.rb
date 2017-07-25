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

  get 'categories/exercises/:name' do #restfullness
    if logged_in?
      @user = current_user
      if @category = WORKOUT_TYPES.find {|cat| cat == params[:name]}
        erb :'/categories/show_exercises'
      else
        flash[:message] = "Category not found!"
        redirect '/categories'
    else
      flash[:message] = "Please login to view this page"
      redirect '/login'
    end
  end

end
