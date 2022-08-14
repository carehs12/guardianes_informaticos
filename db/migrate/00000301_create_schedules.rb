# Creates the main Schedules table
class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.integer :year, null: false
      t.integer :week, null: false

      t.references :service, null: false, foreign_key: true

      t.timestamps
    end
  end
end
