#require 'rack-flash'

class ExercisesController < ApplicationController
  #use Rack::flash

  get '/exercises' do
    if logged_in?
      @all_exercises = Exercise.all
      erb :'/exercises/exercises'
    else
      binding.pry
      session[:message] = "You must be logged in to view the list of exercises"
      redirect '/login'
    end
  end

  get '/exercises/new' do
    if logged_in?
      erb :'/exercises/create_exercises'
    else
      session[:message] = "You must be logged in to create an exercise"
      redirect '/login'
    end
  end

  get '/exercises/:slug' do
    if logged_in?
      if current_exercise 
        erb :'/exercises/show'
      else
        session[:message] = "Cannot find exercise"
        redirect "/users/#{current_user.slug}"
      end
    else
      session[:message] = "You must be logged in to view an exercise"
      redirect '/login'
    end
  end

  post '/exercises' do
    @exercise = Exercise.new(params[:exercise])
    if @exercise.valid?
      @exercise.save
      session[:message] = "Successfully created exercise!"
      redirect '/exercises'
    else
      @errors = @exercise.errors.full_messages.join(', ')
      erb :'/exercises/create_exercises'
    end
  end

end
