require "koala"
require "facescrape/facescrape"
include Facescrape

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :parse_facebook_cookies, :access_token, :setup_global_data

  def parse_facebook_cookies
    @facebook_cookies ||= Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET).get_user_info_from_cookies(cookies)
  end
  
  def access_token
    if @facebook_cookies.kind_of?(Array) || @facebook_cookies.kind_of?(Hash)
      @access_token = @facebook_cookies["access_token"]
      @graph = Koala::Facebook::API.new(@access_token)
    end
  end
  
  def setup_global_data
    # vars = {}
    # var_names = [@graph] # You can put params and anything else really
    # var_names.each do |var|
    #   vars[var.to_s] = session[var]
    # end

    Facescrape::GlobalData.graph = @graph
  end
end
