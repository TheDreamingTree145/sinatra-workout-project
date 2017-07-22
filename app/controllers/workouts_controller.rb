class WorkoutsController < ApplicationController

  get '/workouts' do
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
      flash[:login_mesage] = "You must be logged in to create a workout"
      redirect '/login'
    end
  end
end
