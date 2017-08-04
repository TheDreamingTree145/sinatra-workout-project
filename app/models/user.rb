require './lib/slug_module.rb'

class User < ActiveRecord::Base
  has_many :user_workouts
  has_many :workouts, through: :user_workouts
  has_many :user_exercises
  has_many :exercises, through: :user_exercises

  has_secure_password
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true

  extend SlugHelper

  def slug
    username.downcase.gsub(" ", "-")
  end

  def add_workout(workout)
    if !self.workouts.include?(workout)
      self.workouts << workout
    end
  end

end
