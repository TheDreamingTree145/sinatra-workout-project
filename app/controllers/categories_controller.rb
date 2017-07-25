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

  get '/categories/exercises/:name' do #restfullness
    if logged_in?
      @user = current_user
      @category = params[:name]
      if EXERCISE_TYPES.find {|cat| cat.downcase == @category.downcase}
        @associated_exercises = Exercise.all.select {|cise| cise.category == @category}
        erb :'/categories/show_exercises'
      else
        flash[:message] = "Category not found!"
        redirect '/categories'
      end
    else
      flash[:message] = "Please login to view this page"
      redirect '/login'
    end
  end

  get '/categories/workouts/:name' do #restfullness
    if logged_in?
      @user = current_user
      @category = params[:name]
      if WORKOUT_TYPES.find {|cat| cat.downcase == @category.downcase}
        @associated_workouts = Workout.all.select {|work| work.category == @category}
        erb :'/categories/show_workouts'
      else
        flash[:message] = "Category not found!"
        redirect '/categories'
      end
    else
      flash[:message] = "Please login to view this page"
      redirect '/login'
    end
  end

end
