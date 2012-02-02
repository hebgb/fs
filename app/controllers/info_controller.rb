require "koala"
require "facescrape/facescrape"
include Facescrape

class InfoController < ApplicationController
  
  def index
    begin
      if PostIds.all.length > 0
        @pids = PostIds.order("brand_id ASC, created_at DESC").all
      end
      # @comments = @graph.get_connections("90824638062_10150521227138063", "comments")
    rescue Exception => e
      puts "Exception: #{e}"
      logger.error "#{e}"
    end
  end
  
end
