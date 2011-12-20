class AddColumnsAndModifyFbIdInBrands < ActiveRecord::Migration
  def up
    add_column :brands, :picture, :string
    add_column :brands, :link, :string
    add_column :brands, :likes, :int, :length => 8
    add_column :brands, :category, :string
    add_column :brands, :website, :text
    add_column :brands, :personal_info, :string
    add_column :brands, :talking_about_count, :int
    rename_column :brands, :fb_id, :id
  end

  def down
  end
end