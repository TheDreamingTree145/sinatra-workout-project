require 'rack-flash'

class WorkoutsController < ApplicationController
  use Rack::Flash

  get '/workouts' do #Want to be able to add a workout to a user
    if logged_in?
      @user = current_user
      @all_workouts = Workout.all
      erb :'/workouts/workouts'
    else
      flash[:login_message] = "You must be logged in to see a list of workouts"
      redirect '/login'
    end
  end

  get '/workouts/new' do
    if logged_in?
      @user = current_user
      @all_exercises = Exercise.all
      erb :'/workouts/create_workout'
    else
      flash[:login_message] = "You must be logged in to create a workout"
      redirect '/login'
    end
  end

  post '/workouts' do
    @user = current_user
  end

  post '/workouts/new/exercises' do
    @user = current_user
    if Exercise.all.each {|cise| cise.name.downcase == params[:exercise][:name].downcase}
      flash[:exercise_exists_message] = "That exercise already exists"
      redirect '/workouts/new'
    else
      flash[:exercise_workout_message] = "Successfully added exercise to database"
      redirect 'workouts/new'
    end
  end
end
