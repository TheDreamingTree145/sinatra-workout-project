class ExercisesController < ApplicationController

  get '/exercises' do
    if logged_in?
      @user = current_user
      @all_exercises = Exercise.all
      erb :'/exercises/exercises'
    else
      flash[:message] = "You must be logged in to view the list of exercises"
      redirect '/login'
    end
  end

  get '/exercises/:slug' do
    if logged_in?
      @user = current_user
      @exercise = Exercise.find_by_slug(params[:slug])
      erb :'/exercises/show'
    else
      flash[:message] = "You must be logged in to view an exercise"
      redirect '/login'
    end
  end

  get 'exercises/new' do
    if logged_in?
      @user = current_user
      erb :'/exercises/create_exercises'
    else
      flash[:message] = "You must be logged in to create an exercise"
      redirect '/login'
    end
  end

end
