require "koala"
require "facescrape/facescrape"
include Facescrape

class InfoController < ApplicationController
  before_filter :access_token
  
  def access_token
    @access_token = @facebook_cookies["access_token"]
    @graph = Koala::Facebook::API.new(@access_token)
  end
  
  def index
    @data = PostIds.all
    begin
      @brands = Facescrape::Brands.new(Brand.all)
      @brand_usernames = @brands.brand_usernames
      @posts = Facescrape::Posts.new(@graph, @brand_usernames)
      @post_ids = @posts.list_ids
      @post_ids.each do |id|
        pid = PostIds.new({:post_id => id})
        begin
          pid.save!
        rescue Exception => e
          logger.debug "Exception: #{e}"
        end
      end
    rescue Exception => e
      @data = "Exception: #{e}"
      logger.error "#{e}"
    end
  end
  
  def posts
    @posts_ids = PostIds.all
    
    respond_to do |format|
      format.html
    end
  end
end
