require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_security"
  end

  get "/" do
    erb :welcome
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      @user = User.find(session[:user_id])
    end

    def current_workout
      @workout = Workout.find_by_slug(params[:slug])
    end

    def current_exercise
      @exercise = Exercise.find_by_slug(params[:slug])
    end

    def exercise_created?(workout_hash)
      if workout_hash[:exercise_attributes].values.include?("")
        workout_hash.delete("exercise_attributes")
      end
    end

    @@category = ["Chest", "Arms", "Legs", "Back", "Shoulders"]

    def current_category_exercises
      if @@category.find {|category| category.downcase == params[:name].downcase}
        @category = params[:name]
        @associated_exercises = Exercise.all.select {|exercise| exercise.category.downcase == @category.downcase}
      end
    end

    def current_category_workouts
      if @@category.find {|category| category.downcase == params[:name].downcase}
        @category = params[:name]
        @associated_workouts = Workout.all.select {|workout| workout.category.downcase == @category.downcase}
      end
    end



  end

end
