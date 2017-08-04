require './lib/slug_module.rb'

class Exercise < ActiveRecord::Base
  has_many :user_exercises
  has_many :users, through: :user_exercises
  has_many :workout_exercises
  has_many :workouts, through: :workout_exercises

  validates :name, presence: true, uniqueness: true
  validates :category, presence: true
  validates :sets, presence: true
  validates :reps, presence: true

  @@category = ["Chest", "Arms", "Legs", "Back", "Shoulders"]

  include SlugHelper
  extend SlugHelper

  def self.category
    @@category
  end

end
