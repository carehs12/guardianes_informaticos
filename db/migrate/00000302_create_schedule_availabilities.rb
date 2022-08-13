# Creates the Schedule Availabilities table
class CreateScheduleAvailabilities < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_availabilities do |t|
      t.integer :day, null: false
      t.boolean :hour00, default: false
      t.boolean :hour01, default: false
      t.boolean :hour02, default: false
      t.boolean :hour03, default: false
      t.boolean :hour04, default: false
      t.boolean :hour05, default: false
      t.boolean :hour06, default: false
      t.boolean :hour07, default: false
      t.boolean :hour08, default: false
      t.boolean :hour09, default: false
      t.boolean :hour10, default: false
      t.boolean :hour11, default: false
      t.boolean :hour12, default: false
      t.boolean :hour13, default: false
      t.boolean :hour14, default: false
      t.boolean :hour15, default: false
      t.boolean :hour16, default: false
      t.boolean :hour17, default: false
      t.boolean :hour18, default: false
      t.boolean :hour19, default: false
      t.boolean :hour20, default: false
      t.boolean :hour21, default: false
      t.boolean :hour22, default: false
      t.boolean :hour23, default: false

      t.references :user, null: false, foreign_key: true
      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
