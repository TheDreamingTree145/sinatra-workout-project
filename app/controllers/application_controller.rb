require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  WORKOUT_TYPES = ["Chest", "Arms", "Legs", "Back", "Shoulders"]
  EXERCISE_TYPES = ["Chest", "Arms", "Legs", "Back", "Shoulders"]

  get "/" do
    erb :welcome
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end

  end

end
