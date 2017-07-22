class CreateExercises < ActiveRecord::Migration
  def change
    create_table :exercises do |t|
      t.string :name
      t.string :category
      t.integer :sets
      t.integer :reps
    end
  end
end
