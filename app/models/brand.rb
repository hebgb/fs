class Brand < ActiveRecord::Base
  validates_presence_of :name, :username, :fb_id, :on => :create, :message => "can't be blank"
  
  
end
