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

  get '/workouts/:slug' do
    if logged_in?
      @user = current_user
    else
      flash[:login_message] = "Please login to view a workout"
      redirect '/login'
    end
  end

  post '/workouts' do
    @user = current_user
    if params[:exercises].nil?
      flash[:choose_one] = "Please choose at least one exercise for the workout"
      redirect '/workouts/new'
    end
    @workout = Workout.new(params[:workouts])
    if @workout.valid?
      @user.workouts << @workout
      params[:exercises].each do |id|
        if !@user.exercises.include?(Exercise.all.find_by_id(id))
          @user.exercises << Exercise.all.find_by_id(id)
        end
        @workout.exercises << Exercise.all.find_by_id(id)
      end
      @workout.created_by = @user.username #do i want the object here?
      @user.save
      @workout.save
      redirect "/workouts/#{@workout.slug}"
    else
      flash[:workout_create_message] = "Please make sure all fields are filled out when creating a new workout"
      redirect '/workouts/new'
    end
  end

  post '/workouts/new/exercises' do
    @user = current_user
    @all_exercises = Exercise.all
  # Necessary only on first instance
  #  if @all_exercises.empty?
  #    @exercise = Exercise.new(params[:exercise])
  #    if @exercise.valid?
  #      @exercise.save
  #      flash[:exercise_create_message] = "Successfully added exercise to database"
  #      redirect '/workouts/new'
  #    end
  #  end
    @all_exercises.each do |cise|
      if cise.name.downcase == params[:exercise][:name].downcase
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
    end
  end


end
