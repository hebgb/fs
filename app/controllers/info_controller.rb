require "koala"
require "facescrape/facescrape"
include Facescrape

class InfoController < ApplicationController
  before_filter :access_token
  
  def parse_facebook_cookies
    # begin
    #   @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    # rescue Exception => e
    #   # @facebook_cookies ||= Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET).get_user_info_from_cookie(cookies)
    # end  
    @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    if @facebook_cookies.nil?
      redirect_to :controller => "info", :action => "parse_facebook_cookies"
    end
  end
  
  def access_token
    @access_token = @facebook_cookies["access_token"]
    @graph = Koala::Facebook::API.new(@access_token)
  end
  
  def index
    # @data = PostIds.all
    begin
      if PostIds.all.length > 0
        @pids = PostIds.order("brand_id ASC, created_at DESC").all
      end
      @fs_brands = Facescrape::Brands.new(Brand.all)
      @brand_usernames = @fs_brands.brand_usernames
      @fs_posts = Facescrape::Posts.new(@graph, @brand_usernames)
      @post_ids = @fs_posts.list_ids
      @post_ids.each do |id|
        @id = @fs_posts.split_id(id)
        pid = PostIds.new({:brand_id => @id[0], :post_id => @id[1]})
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
    @post_ids = PostIds.order("brand_id ASC, created_at DESC").all
    @fs_posts = Facescrape::Posts.new(@graph)
    @posts = @fs_posts.list_posts(@post_ids)
    
    respond_to do |format|
      format.html
    end
  end
end
