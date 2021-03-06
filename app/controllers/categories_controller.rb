#require 'rack-flash'

class CategoriesController < ApplicationController
  #use Rack::flash

  get '/categories' do
    if logged_in?
      @user = current_user
      erb :'/categories/categories'
    else
      session[:message] = "Please login or signup to view categories"
      redirect '/login'
    end
  end

  get '/categories/exercises/:name' do #restfullness
    if logged_in?
      @user = current_user
      @category = params[:name]
      if EXERCISE_TYPES.find {|cat| cat.downcase == @category.downcase}
        @associated_exercises = Exercise.all.select {|cise| cise.category.downcase == @category.downcase}
        erb :'/categories/show_exercises'
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
      @user = current_user
      @category = params[:name]
      if WORKOUT_TYPES.find {|cat| cat.downcase == @category.downcase}
        @associated_workouts = Workout.all.select {|work| work.category.downcase == @category.downcase}
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
