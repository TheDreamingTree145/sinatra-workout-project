class Exercise < ActiveRecord::Base
  has_many :user_exercises
  has_many :users, through: :user_exercises
  has_many :workout_exercises
  has_many :workouts, through: :workout_exercises

  def slug
    name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|user| user.slug == slug}
  end
end
