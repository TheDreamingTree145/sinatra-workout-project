class User < ActiveRecord::Base
  has_many :user_workouts
  has_many :workouts, through: :user_workouts
  has_many :user_exercises
  has_many :exercises, through: :user_exercises

  has_secure_password
  validates_presence_of :username, :email, :password

  def slug
    name.downcase.gsub(" ", "-")
  end

  def self.find_by_slug(slug)
    self.all.find {|user| user.slug == slug}
  end

end
