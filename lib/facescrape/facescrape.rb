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
    def initialize(graph, brands)
      @graph = graph
      @brands = brands
    end
    attr_reader :graph, :brands
    
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
      @posts = Array.new
      post_ids.each do |pid|
        @posts << @graph.get_object(pid)
      end
      return @posts
    end
  end
end