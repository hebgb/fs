require "koala"

class ApplicationController < ActionController::Base
  protect_from_forgery
  
  before_filter :parse_facebook_cookies

  def parse_facebook_cookies
    begin
      @facebook_cookies ||= Koala::Facebook::OAuth.new(Facebook::APP_ID, Facebook::SECRET).get_user_info_from_cookie(cookies)  
    rescue Exception => e
      
    end   

    # If you've setup a configuration file as shown above then you can just do
    # @facebook_cookies ||= Koala::Facebook::OAuth.new.get_user_info_from_cookie(cookies)
  end
end
