class ChangeIdToFbIdOnBrands < ActiveRecord::Migration
  def up
    add_column :brands, :fb_id, :int, :length => 8
  end

  def down
  end
end