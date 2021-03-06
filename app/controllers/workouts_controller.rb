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
      @all_exercises = Exercise.all
      erb :'/workouts/create_workout'
    else
      session[:message] = "You must be logged in to create a workout"
      redirect '/login'
    end
  end

  get '/workouts/:slug' do
    if logged_in?
<<<<<<< HEAD
      if current_workout
<<<<<<< HEAD
        binding.pry
=======
      if @workout = Workout.find_by_slug(params[:slug])
>>>>>>> parent of d192a91... uhh lots of changes
=======
>>>>>>> parent of cf064c9... reset database
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
<<<<<<< HEAD
<<<<<<< HEAD
    if @workout.valid? && !@workout.exercises.empty?
      @workout.save
=======
    if Workout.name_taken?(params[:workout]) || (Exercise.name_taken?(params[:workout][:exercise_attributes]) unless params[:workout][:exercise_attributes].nil?)
      session[:message] = "Workout name or exercise taken"
      redirect '/workouts/new'
    end
    if @workout.exercise_check
      session[:message] = "Please select at least one exercise"
      redirect '/workouts/new'
    end
    if @workout.save
      current_user.workouts << @workout #build not associating
      current_user.exercise_ids=(@workout.exercise_ids)
>>>>>>> parent of d192a91... uhh lots of changes
      binding.pry
=======
    if current_workout.valid? && !current_workout.exercises.empty?
      current_workout.save
      current_user.workouts << current_workout #build not associating
>>>>>>> parent of cf064c9... reset database
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

  post '/workouts/exercises/edit' do #could be ugly restfullness
    @user = current_user
    Exercise.all.find do |cise|
      if cise.name.downcase == params[:exercise][:name].downcase
        session[:message] = "That exercise already exists"
        redirect "/workouts/#{params.keys[0]}/edit"
      end
    end
    @exercise = Exercise.new(params[:exercise])
    if @exercise.valid?
      @exercise.save
      session[:message] = "Successfully added exercise to database"
      redirect "/workouts/#{params.keys[0]}/edit" #funky to get to reload right page to edit
    else
      session[:message] = "Please make sure all fields are filled out when creating a new exercise"
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
        session[:message] = "You can only edit workouts you have created"
        redirect "/users/#{@user.slug}"
      end
    else
      session[:message] = "Login to edit or delete a workout"
      redirect '/login'
    end
  end

  post '/workouts/users/:slug/add' do
    @user = current_user
    @workout = Workout.find_by_slug(params.keys[0])
    if !@user.workouts.include?(@workout)
      @user.workouts << @workout
      @workout.exercises.each do |cise|
        if !@user.exercises.include?(cise)
          @user.exercises << cise
        end
      end
      session[:message] = "Successfully added workout!"
      redirect "/users/#{@user.slug}"
    else
      session[:message] = "You already have this workout!"
      redirect "/workouts/#{params.keys[0]}"
    end
  end

  patch '/workouts/:slug' do
    @workout = Workout.find_by_slug(params[:slug])
    params[:workouts].each do |attr|
      if attr.empty?
        session[:message] = "Please make sure all fields are filled out"
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
