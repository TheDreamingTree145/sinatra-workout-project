require './lib/slug_module.rb'

class Exercise < ActiveRecord::Base
  has_many :user_exercises
  has_many :users, through: :user_exercises
  has_many :workout_exercises
  has_many :workouts, through: :workout_exercises

  validates_presence_of :name, :category, :sets, :reps

  @@category = ["Chest", "Arms", "Legs", "Back", "Shoulders"]

  def self.category
    @@category
  end

  include SlugHelper
  extend SlugHelper

end
