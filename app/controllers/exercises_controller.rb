#require 'rack-flash'

class ExercisesController < ApplicationController
  #use Rack::flash

  get '/exercises' do
    if logged_in?
      @user = current_user
      @all_exercises = Exercise.all
      erb :'/exercises/exercises'
    else
      session[:message] = "You must be logged in to view the list of exercises"
      redirect '/login'
    end
  end

  get '/exercises/new' do
    if logged_in?
      @user = current_user
      erb :'/exercises/create_exercises'
    else
      session[:message] = "You must be logged in to create an exercise"
      redirect '/login'
    end
  end

  get '/exercises/:slug' do
    if logged_in?
      @user = current_user
      if @exercise = Exercise.find_by_slug(params[:slug])
        erb :'/exercises/show'
      else
        session[:message] = "Cannot find exercise"
        redirect "/users/#{@user.slug}"
      end
    else
      session[:message] = "You must be logged in to view an exercise"
      redirect '/login'
    end
  end

  post '/exercises' do
    if Exercise.name_taken?(params[:exercise])
        session[:message] = "That exercise already exists"
        redirect '/exercises/new'
    end
    @exercise = Exercise.new(params[:exercise])
    if @exercise.save
      session[:message] = "Successfully created exercise!"
      redirect '/exercises'
    else
      @errors = @exercise.errors.full_messages.join(', ')
      binding.pry
      erb :'/exercises/create_exercises'
    end
  end

end
