class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.integer :post_id
      t.string :message
      t.string :picture
      t.string :link
      t.string :name
      t.string :caption
      t.string :description
      t.string :icon
      t.string :type
      t.datetime :post_created_time
      t.datetime :post_updated_time
      t.integer :likes_count
      t.integer :comments_count

      t.timestamps
    end
  end
end
