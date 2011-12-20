class PostIds < ActiveRecord::Base
  validates_uniqueness_of :post_id, :on => :create, :message => "must be unique"
end
