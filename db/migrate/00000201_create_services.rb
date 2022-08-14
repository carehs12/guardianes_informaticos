# Creates the main Services table
class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name, null: false

      t.integer :mon_hour_start
      t.integer :mon_hour_end
      t.integer :tue_hour_start
      t.integer :tue_hour_end
      t.integer :wed_hour_start
      t.integer :wed_hour_end
      t.integer :thu_hour_start
      t.integer :thu_hour_end
      t.integer :fri_hour_start
      t.integer :fri_hour_end
      t.integer :sat_hour_start
      t.integer :sat_hour_end
      t.integer :sun_hour_start
      t.integer :sun_hour_end

      t.timestamps
    end

    add_index :services, :name, unique: true
  end
end
