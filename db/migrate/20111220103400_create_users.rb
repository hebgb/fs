class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :user_id
      t.string :name
      t.string :first_name
      t.string :last_name
      t.string :link
      t.string :username
      t.string :gender
      t.string :locale

      t.timestamps
    end
  end
end
