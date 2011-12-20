class CreatePostIds < ActiveRecord::Migration
  def change
    create_table :post_ids do |t|
      t.integer :post_id

      t.timestamps
    end
  end
end
