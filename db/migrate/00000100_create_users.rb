# Creates the main Users table following devise standard
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      ## Database authenticatable
      t.string :username,           null: false
      t.string :encrypted_password, null: false
      t.string :email

      ## Recoverable
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.timestamps
    end

    add_index :users, :username, unique: true
    add_index :users, :reset_password_token, unique: true
  end
end
