module Facescrape
  class Filter
    def initialize(data_obj)
      @data = data_obj
    end
    attr_reader :data
    
    def brand_ids
      ids = Array.new
      @data.each do |d|
        ids << d['id']
      end
      ids
    end
    
    def save_post_ids(ids)
      # ids.each { |id| 
      #   pid = PostsIds.new(id)
      #   begin
      #     pid.save!  
      #   rescue Exception => e
      #     logger.error
      #   end
      # }
      id_arr = Array.new
      ids.each do |id|
        debugger
        id_arr << PostIds.new({:post_id => id})
      end
      id_arr.each do |ida|
        begin
          ida.save!
        rescue Exception => e
          logger.error
        end
      end
    end
    
  end
end