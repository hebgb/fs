require "koala"
require "timeout"

module Facescrape  
  class GlobalData
    # This is a Locator/Broker class for global data that
    # Needs to be accessible everywhere!
    def self.method_missing(sym, *args, &block)
      @@attrs ||= {}
      sym = sym.to_s
      if sym.include? "=" then
        @@attrs[sym.gsub('=','')] = args.first
      else
        if @@attrs[sym].class == Hash then
          return ValueProxy.new(@@attrs[sym])
        else
          return @@attrs[sym]
        end
      end
    end
  end

  class ValueProxy
    def initialize(attrs)
      @attrs = attrs
    end
    def method_missing(sym,*args,&block)
      sym = sym.to_s
      if @attrs[sym] then
        if @attrs[sym].class == Hash then
          return ValueProxy.new(@attrs[sym])
        else
          return @attrs[sym]
        end
      end
    end
  end
  
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
      ids = []
      threads = []
      mutex = Mutex.new
      @brands.each do |brand|
        threads << Thread.new(brand) do |b|
          feed = @graph.get_connections(b, "feed")
          feed.each do |f|
            mutex.synchronize do
              ids << f["id"]
            end
          end
        end
      end
      threads.each { |thr| thr.join }
      return ids
    end
    
    def list_posts(post_ids)
      if post_ids.kind_of?(Array)
        posts = []
        threads = []
        mutex = Mutex.new
        post_ids.each do |pid|
          threads << Thread.new(pid) do |p|
            id = Utilities::Util.join_id([p.brand_id, p.post_id])
            mutex.synchronize do
              if @graph.get_object(id)
                begin
                  status = Timeout::timeout(10) {
                    posts << @graph.get_object(id)
                  }
                rescue Timeout::Error
                  puts "Taking too long, exiting..."
                end
              else
                @post = PostIds.where("post_id = ?", p.post_id).first
                @post.destroy
              end
            end
          end
        end
      else
        # @posts = @graph.get_object(post_ids.post_id)
        posts = post_ids.class
      end
      threads.each { |thr| thr.join }
      return posts
    end
  end
  
  class Comments
    def initialize(*args)
      if args.length == 1
        @graph = args[0]
      elsif args.length == 2
        @graph = args[0]
        @posts = args[1]
      end
    end
    
    def list_ids
      ids = []
      threads = []
      mutex = Mutex.new
      @posts.each do |post|
        threads << Thread.new(post) do |p|
          id = Utilities::Util.join_id([p.brand_id, p.post_id])
          comments = @graph.get_connections(id, "comments")
          comments.each do |c|
            mutex.synchronize do
              ids << c["id"]
            end
          end
        end
      end
      threads.each { |thr| thr.join }
      return ids
    end
    
    def list_comments
      
    end    
  end
  
  class Collector    
    def get_post_ids
      begin
        puts "Start: #{Time.now}"
        if GlobalData.graph
          fs_brands = Brands.new(Brand.all)
          brand_usernames = fs_brands.brand_usernames
          fs_posts = Posts.new(GlobalData.graph, brand_usernames)
          post_ids = fs_posts.list_ids
          post_ids.each do |id|
            @id = Utilities::Util.split_id(id)
            pid = PostIds.new({:brand_id => @id[0], :post_id => @id[1]})
            begin
              pid.save!
            rescue Exception => e
              puts "Exception: #{e}"
            end
          end
        end
        puts "Finish: #{Time.now}"
      rescue Exception => e
        puts "Exception: #{e}"
        abort
      end
    end
    
    def get_posts
      begin
        puts "Start: #{Time.now}"
        if GlobalData.graph
          post_ids = PostIds.where(:has_post => false).limit(10).all
          fs_posts = Posts.new(GlobalData.graph)
          posts = fs_posts.list_posts(post_ids)
          posts.each do |post|    
            post_id = Utilities::Util.split_id(post["id"])
            obj = Hash.new
            obj["brand_id"]          = post_id[0] if post_id[0]
            obj["post_id"]           = post_id[1] if post_id[1]
            obj["message"]           = post["message"] if post["message"]
            obj["picture"]           = post["picture"] if post["picture"]
            obj["link"]              = post["link"] if post["link"]
            obj["name"]              = post["name"] if post["name"]
            obj["caption"]           = post["caption"] if post["caption"]
            obj["description"]       = post["description"] if post["description"]
            obj["icon"]              = post["icon"] if post["icon"]
            obj["type"]              = post["type"] if post["type"]
            obj["post_created_time"] = post["created_time"] if post["created_time"]
            obj["post_updated_time"] = post["updated_time"] if post["updated_time"]
            obj["likes_count"]       = post["likes"]["count"] if post["likes"]
            obj["comments_count"]    = post["comments"]["count"] if post["comments"]["count"]
            puts "Make object"
            p = Post.new(obj)
            begin
              puts "Saving..."
              if p.save!
                puts "Saved"
                if @post = PostIds.where(:brand_id => p.brand_id, :post_id => p.post_id).first
                  @post.update_attribute(:has_post, true)
                  puts "Updated attribute"
                end
              end
            rescue Exception => e
              puts "Exception 1: #{e}"
              abort
            end            
          end
        end
        puts "Finish: #{Time.now}"
      rescue Timeout::Error
        puts "Taking too long, exiting..."
      rescue Exception => e
        puts "Exception 2: #{e}"
        abort
      end      
    end
    
    def get_comment_ids
      begin
        puts "Start: #{Time.now}"
        if GlobalData.graph
          # fs_posts = Posts.new(GlobalData.graph)
          posts = Post.where("comment_check IS NULL").limit(10).all
          if posts.length < 1
            posts = Post.order("comment_check ASC").limit(10).all
          end
          fs_comments = Comments.new(GlobalData.graph, posts)
          comment_ids = fs_comments.list_ids
          comment_ids.each do |comment_id|
            id = Utilities::Util.split_id(comment_id)            
            cid = CommentIds.new({:brand_id => id[0], :post_id => id[1], :comment_id => id[2]})
            begin
              if cid.save!
                if @post = Post.where(:brand_id => cid.brand_id, :post_id => cid.post_id).first
                  @post.update_attribute(:comment_check, DateTime.now)
                end
              end
            rescue Exception => e
              puts "Comments Exception 1 : #{e}"
            end
          end
        end
        puts "Finish #{Time.now}"
      rescue Exception => e
        puts "Comments Exception 2: #{e}"
        abort
      end            
    end
  end
  
  def get_comments
    begin
      puts "Start: #{Time.now}"
      if GlobalData.graph

      end
      puts "Finish #{Time.now}"
    rescue Exception => e
      puts "Exception: #{e}"
      abort
    end
  end
  
  module Utilities
    class Util
      def self.split_id(id)
        id.split("_")
      end

      def self.join_id(id)
        id.join("_")
      end
    end
  end
end