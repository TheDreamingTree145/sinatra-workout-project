require 'rack-flash'

class WorkoutsController < ApplicationController
  use Rack::Flash

  get '/workouts' do #Want to be able to add a workout to a user
    if logged_in?
      @user = current_user
      @all_workouts = Workout.all
      erb :'/workouts/workouts'
    else
      flash[:message] = "You must be logged in to see a list of workouts"
      redirect '/login'
    end
  end

  get '/workouts/new' do
    if logged_in?
      @user = current_user
      @all_exercises = Exercise.all
      erb :'/workouts/create_workout'
    else
      flash[:message] = "You must be logged in to create a workout"
      redirect '/login'
    end
  end

  get '/workouts/:slug' do
    if logged_in?
      @user = current_user
      @workout = Workout.find_by_slug(params[:slug])
      erb :'/workouts/show'
    else
      flash[:message] = "Please login to view a workout"
      redirect '/login'
    end
  end

  post '/workouts' do
    @user = current_user
    if params[:exercises].nil?
      flash[:message] = "Please choose at least one exercise for the workout"
      redirect '/workouts/new'
    end
    Workout.all.find do |workout|
      if workout.name.downcase == params[:workouts][:name].downcase
        flash[:message] = "That workout name is taken. Please choose another"
        redirect '/workouts/new'
      end
    end
    @workout = Workout.new(params[:workouts])
    if @workout.valid?
      @user.workouts << @workout
      @workout.exercise_ids = params[:exercises]
      @workout.exercises.each do |cise|
        if !@user.exercises.include?(cise)
          @user.exercises << cise
        end
      end
      @workout.created_by = @user.username #do i want the object here?
      @user.save
      @workout.save
      flash[:message] = "You have successfully created a workout!"
      redirect "/workouts/#{@workout.slug}"
    else
      flash[:message] = "Please make sure all fields are filled out when creating a new workout"
      redirect '/workouts/new'
    end
  end

  post '/workouts/exercises/new' do #not sure about
    @user = current_user
  # Necessary only on first instance
  #  if @all_exercises.empty?
  #    @exercise = Exercise.new(params[:exercise])
  #    if @exercise.valid?
  #      @exercise.save
  #      flash[:exercise_create_message] = "Successfully added exercise to database"
  #      redirect '/workouts/new'
  #    end
  #  end
    Exercise.all.find do |cise|
      if cise.name.downcase == params[:exercise][:name].downcase
        flash[:message] = "That exercise already exists"
        redirect '/workouts/new'
      end
    end
    @exercise = Exercise.new(params[:exercise])
    if @exercise.valid?
      @exercise.save
      flash[:message] = "Successfully added exercise to database"
      redirect '/workouts/new'
    else
      flash[:message] = "Please make sure all fields are filled out when creating a new exercise"
      redirect '/workouts/new'
    end
  end

  post '/workouts/exercises/edit' do #could be ugly restfullness
    @user = current_user
    Exercise.all.find do |cise|
      if cise.name.downcase == params[:exercise][:name].downcase
        flash[:message] = "That exercise already exists"
        redirect "/workouts/#{params.keys[0]}/edit"
      end
    end
    @exercise = Exercise.new(params[:exercise])
    if @exercise.valid?
      @exercise.save
      flash[:message] = "Successfully added exercise to database"
      redirect "/workouts/#{params.keys[0]}/edit" #funky to get to reload right page to edit
    else
      flash[:message] = "Please make sure all fields are filled out when creating a new exercise"
      redirect "/workouts/#{params.keys[0]}/edit"
    end
  end

  get '/workouts/:slug/edit' do
    if logged_in?
      @user = current_user
      @workout = Workout.find_by_slug(params[:slug])
      @all_exercises = Exercise.all
      if @user.username == @workout.created_by
        erb :'/workouts/edit'
      else
        flash[:message] = "You can only edit workouts you have created"
        redirect "/users/#{@user.slug}"
      end
    else
      flash[:message] = "Login to edit or delete a workout"
      redirect '/login'
    end
  end

  post '/workouts/users/:slug/add' do
    @user = current_user
    if !@user.workouts.include?(params.keys[0])
      @user.workouts << params.keys[0]
      flash[:message] = "Successfully added workout!"
      redirect "/users/#{@user.slug}"
    else
      flash[:message] = "You already have this workout!"
      redirect "/workouts/#{params.keys[0]}"
    end
  end

  patch '/workouts/:slug' do
    @workout = Workout.find_by_slug(params[:slug])
    params[:workouts].each do |attr|
      if attr.empty?
        flash[:message] = "Please make sure all fields are filled out"
        redirect "/workouts/#{@workout.slug}/edit"
      end
    end
    @workout.update(params[:workouts])
    @workout.exercise_ids = params[:exercises]
    @workout.save
    redirect "/workouts/#{@workout.slug}"
  end

  delete '/workouts/:slug/delete' do #don't know why I would need check again
    @workout = Workout.find_by_slug(params[:slug])
    @user = current_user
    @workout.destroy
    redirect "/users/#{@user.slug}"
  end



end
