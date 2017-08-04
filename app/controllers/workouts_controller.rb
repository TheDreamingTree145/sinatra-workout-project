# require 'rack-flash'

class WorkoutsController < ApplicationController
  # use Rack::Flash

  get '/workouts' do #current_user done
    if logged_in?
      @all_workouts = Workout.all
      erb :'/workouts/workouts'
    else
      session[:message] = "You must be logged in to see a list of workouts"
      redirect '/login'
    end
  end

  get '/workouts/new' do #current_user done
    if logged_in?
      binding.pry
      @all_exercises = Exercise.all
      erb :'/workouts/create_workout'
    else
      session[:message] = "You must be logged in to create a workout"
      redirect '/login'
    end
  end

  get '/workouts/:slug' do
    if logged_in?
      if current_workout
        erb :'/workouts/show'
      else
        session[:message] = "Could not find workout"
        redirect '/workouts'
      end
    else
      session[:message] = "Please login to view a workout"
      redirect '/login'
    end
  end

  # I believe one of my big problems are that my associations are messed up or incorrect.

  post '/workouts' do
    redirect to '/login' if !logged_in?
    exercise_created?(params[:workout]) #check if new exercise created
    current_user.workouts.build(params[:workout])
    # couldn't get build to associate the damn artist
    if current_workout.valid? && !current_workout.exercises.empty?
      current_workout.save
      current_user.workouts << current_workout #build not associating
      session[:message] = "Successfully created workout!"
      redirect "/workouts/#{current_workout.slug}"
    else
      @errors = current_workout.errors.full_messages.join(', ')
      erb :'/workouts/create_workout'
    end
  end
  #   {
  #     woooooooooooooooooorkout: {
  #       name: "",
  #       categyory: '',
  #       exercise_ids: [1,3,4],
  #       exercise_attributes: {
  #         name: "",
  #         categroy: "",
  #         sets: 1,
  #         reps: 11
  #       }
  #     }
  #   }
  #
  #
  #
  #
  #
  # #   @user = current_user
  # #   if params[:exercises].nil?
  #     session[:message] = "Please choose at least one exercise for the workout"
  #     redirect '/workouts/new'
  #   end
  #   Workout.all.find do |workout|
  #     if workout.name.downcase == params[:workouts][:name].downcase
  #       session[:message] = "That workout name is taken. Please choose another"
  #       redirect '/workouts/new'
  #     end
  #   end
  #   @workout = Workout.new(params[:workouts])
  #   if @workout.valid?
  #     @user.workouts << @workout
  #     @workout.exercise_ids = params[:exercises]
  #
  #     @workout.created_by = @user.username #do i want the object here?
  #     @user.save
  #     @workout.save
  #     session[:message] = "You have successfully created a workout!"
  #     redirect "/workouts/#{@workout.slug}"
  #   else
  #     session[:message] = "Please make sure all fields are filled out when creating a new workout"
  #     redirect '/workouts/new'
  #   end
  # end

  get '/workouts/:slug/edit' do
    if logged_in?
      @all_exercises = Exercise.all
      if current_user.username == current_workout.created_by
        erb :'/workouts/edit'
      else
        session[:message] = "You can only edit workouts you have created"
        redirect "/users/#{current_user.slug}"
      end
    else
      session[:message] = "Login to edit or delete a workout"
      redirect '/login'
    end
  end

  post '/workouts/:slug/add' do
    if current_user.add_workout(current_workout)
      session[:message] = "Successfully added workout!"
      redirect "/workouts/#{current_workout.slug}"
    else
      session[:message] = "You already have this workout!"
      redirect "/workouts/#{current_workout.slug}"
    end
  end

  # editing a workout add exercises fine, but doesn't remove them if they are unchecked.. Fricked up here.

  patch '/workouts/:slug' do #not updating ids
    exercise_created?(params[:workout])
    current_workout.update(params[:workout])
    current_workout.exercise_ids = params[:workout][:exercise_ids]
    redirect "/workouts/#{current_workout.slug}"
  end

  delete '/workouts/:slug/delete' do #don't know why I would need check again
    current_workout.destroy
    redirect "/users/#{current_user.slug}"
  end

end
