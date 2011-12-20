class CreateBrands < ActiveRecord::Migration
  def change
    create_table :brands do |t|
      t.string :name
      t.string :username
      t.integer :fb_id

      t.timestamps
    end
  end
end
