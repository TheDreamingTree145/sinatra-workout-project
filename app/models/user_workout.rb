class UserWorkout < ActiveRecord::Base
  belongs_to :user
  belongs_to :workout

end
