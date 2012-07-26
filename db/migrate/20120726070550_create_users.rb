class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :login, null: false, limit: 64
      t.string :full_name, limit: 64
      t.string :password_hash, null: false, limit: 64
      t.string :auth_token

      t.timestamps
    end
  end
end
