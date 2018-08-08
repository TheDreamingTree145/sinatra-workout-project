require './lib/slug_module.rb'

class User < ActiveRecord::Base
  has_many :user_workouts
  has_many :workouts, through: :user_workouts
  has_many :user_exercises
  has_many :exercises, through: :user_exercises

  has_secure_password
  validates_presence_of :username, :email, :password

  extend SlugHelper

  def slug
    username.downcase.gsub(" ", "-")
  end

  def exercise_ids=(exercise_ids) # ???
    exercise_ids.each do |id|
      if !self.exercises.include?(Exercise.find_by_id(id))
        self.exercises << Exercise.find_by_id(id)
      end
    end
  end

end
