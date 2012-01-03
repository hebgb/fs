require "koala"

module Facescrape
  class Brands
    def initialize(brands)
      @brands = brands
    end
    attr_reader :brands
    
    def list_brands
      @brands
    end
    
    def brand_usernames
      ids = Array.new
      @brands.each do |b|
        ids << b['username']
      end
      ids
    end
  end
  
  class Posts
    def initialize(*args)
      if args.length == 1
        @graph = args[0]
      elsif args.length == 2
        @graph = args[0]
        @brands = args[1]
      end
    end
    
    def list_ids
      @f = Array.new
      @brands.each do |brand|
        @feed = @graph.get_connections(brand, "feed")        
        @feed.each do |g|
          @f << g["id"]
        end  
      end
      return @f
    end
    
    def list_posts(post_ids)
      if post_ids.kind_of?(Array)
        @posts = Array.new
        post_ids.each do |pid|
          id = self.join_id([pid.brand_id, pid.post_id])
          @posts << @graph.get_object(id)
        end
        # post_ids.each { |pid| @posts << @graph.get_object(pid.post_id) }
      else
        @posts = @graph.get_object(post_ids.post_id)
      end
      return @posts
    end
    
    def split_id(id)
      id.split("_")
    end
    
    def join_id(id)
      id.join("_")
    end
  end
end