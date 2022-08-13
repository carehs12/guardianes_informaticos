# Creates the main Services table
class CreateServices < ActiveRecord::Migration[7.0]
  def change
    create_table :services do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :services, :name, unique: true
  end
end
