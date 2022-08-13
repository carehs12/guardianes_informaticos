# Creates the Schedule Results table
class CreateScheduleResults < ActiveRecord::Migration[7.0]
  def change
    create_table :schedule_results do |t|
      t.bigint :day, null: false
      t.bigint :hour00
      t.bigint :hour01
      t.bigint :hour02
      t.bigint :hour03
      t.bigint :hour04
      t.bigint :hour05
      t.bigint :hour06
      t.bigint :hour07
      t.bigint :hour08
      t.bigint :hour09
      t.bigint :hour10
      t.bigint :hour11
      t.bigint :hour12
      t.bigint :hour13
      t.bigint :hour14
      t.bigint :hour15
      t.bigint :hour16
      t.bigint :hour17
      t.bigint :hour18
      t.bigint :hour19
      t.bigint :hour20
      t.bigint :hour21
      t.bigint :hour22
      t.bigint :hour23

      t.references :schedule, null: false, foreign_key: true

      t.timestamps
    end
  end
end
