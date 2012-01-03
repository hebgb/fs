require "koala"

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :parse_facebook_cookies

  def parse_facebook_cookies
    begin
      @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    rescue Exception => e
      # @facebook_cookies ||= Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET).get_user_info_from_cookie(cookies)
    end  
    # @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
    # if @facebook_cookies
    #   
    # else 
    #   redirect_to :controller => "info", :action => "index"
    # end
  end
end
