# Creates the User Details table, to separate the info used
#   by devise from the one used for the application
class CreateUserDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :user_details do |t|
      t.string :first_names
      t.string :last_names
      t.datetime :birth_date
      t.text :address
      t.text :personal_phone
      t.text :emergency_phone

      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
