class WorkoutsController < ApplicationController

  get '/workouts' do
    if logged_in?
      @user = current_user
      @all_workouts = Workout.all
      erb :'/workouts/workouts'
    else
      flash[:login_message]
      redirect '/login'
    end
  end
end
