require './lib/slug_module.rb'

class Workout < ActiveRecord::Base
  has_many :user_workouts
  has_many :users, through: :user_workouts
  has_many :workout_exercises
  has_many :exercises, through: :workout_exercises

  validates_presence_of :name, :category

  include SlugHelper
  extend SlugHelper

end
