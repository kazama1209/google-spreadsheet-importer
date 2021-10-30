class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :student_name
      t.string :gender
      t.string :class_level
      t.string :home_state
      t.string :major
      t.string :extracurricular_activity

      t.timestamps
    end
  end
end
