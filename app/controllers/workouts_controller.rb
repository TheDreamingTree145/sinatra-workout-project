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
    @all_exercises = Exercise.all
    if !@all_exercises.empty?
      if @all_exercises.each {|cise| cise.name.downcase == params[:exercise][:name].downcase}
        flash[:exercise_create_message] = "That exercise already exists"
        redirect '/workouts/new'
      else
        @exercise = Exercise.new(params[:exercise])
        if @exercise.valid?
          @exercise.save
          flash[:exercise_create_message] = "Successfully added exercise to database"
          redirect '/workouts/new'
        else
          flash[:exercise_create_message] = "Please make sure all fields are filled out when creating a new exercise"
          redirect '/workouts/new'
        end
      end
    else
      @exercise = Exercise.new(params[:exercise])
      if @exercise.valid?
        @exercise.save
        flash[:exercise_create_message] = "Successfully added exercise to database"
        redirect 'workouts/new'
      else
        flash[:exercise_create_message] = "Please make sure all fields are filled out when creating a new exercise"
        redirect '/workouts/new'
      end
    end
  end
end
