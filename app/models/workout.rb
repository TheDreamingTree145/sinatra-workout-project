require './lib/slug_module.rb'

class Workout < ActiveRecord::Base
  has_many :user_workouts
  has_many :users, through: :user_workouts
  has_many :workout_exercises
  has_many :exercises, through: :workout_exercises

  validates_presence_of :name, :category

  @@category = ["Chest", "Arms", "Legs", "Back", "Shoulders"]

  include SlugHelper
  extend SlugHelper

  def self.category
    @@category
  end

  def exercise_attributes=(exercise_attributes)
    self.exercises.build(exercise_attributes)
  end

  def exercise_ids=(exercise_ids) #yuck
    exercise_ids.each do |id|
      self.exercises << Exercise.find_by_id(id)
    end
  end

  def exercise_check
    self.exercises.empty?
  end

end
