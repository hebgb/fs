require "koala"
require "facescrape/facescrape"
include Facescrape

class InfoController < ApplicationController
  def index
    @info = PostIds.all
    begin
      @access_token = @facebook_cookies["access_token"]
      @graph = Koala::Facebook::API.new(@access_token)
      @g = @graph.get_connections("paulsmithdesign", 'feed')
      @filter = Filter.new(@g)
      @data = @filter.brand_ids
      @filter.save_post_ids(@data)
    rescue Exception => e
      @data = "Could not find page data."
    end
  end
  
  def create
    begin
      @access_token = @facebook_cookies["access_token"]
      @graph = Koala::Facebook::API.new(@access_token)
      @g = @graph.get_connections("paulsmithdesign", 'feed')
      @filter = Filter.new(@g)
      @data = @filter.brand_ids
      @filter.save_post_ids(@data)
      
    rescue Exception => e
      @data = "Could not find page data."
    end
  end

end
