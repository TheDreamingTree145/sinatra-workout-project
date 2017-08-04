#require 'rack-flash'

class CategoriesController < ApplicationController
  #use Rack::flash

  get '/categories' do
    if logged_in?
      erb :'/categories/categories'
    else
      session[:message] = "Please login or signup to view categories"
      redirect '/login'
    end
  end

  get '/categories/exercises/:name' do #restfullness
    if logged_in?
      if current_category_exercises
        erb :'categories/show_exercises'
      else
        session[:message] = "Category not found!"
        redirect '/categories'
      end
    else
      session[:message] = "Please login to view this page"
      redirect '/login'
    end
  end

  get '/categories/workouts/:name' do #restfullness
    if logged_in?
      if current_category_workouts
        erb :'/categories/show_workouts'
      else
        session[:message] = "Category not found!"
        redirect '/categories'
      end
    else
      session[:message] = "Please login to view this page"
      redirect '/login'
    end
  end

end
