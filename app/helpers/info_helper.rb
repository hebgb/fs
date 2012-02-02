module InfoHelper
  def filter_ids(id, data)
    text = ''
    # ids = Array.new
    data.each do |d|
      if d['id'].start_with?("#{id}_")
        text <<  "#{d['id']}<br>"
      end
    end
    text.html_safe
  end
  
  def total_num_brands
    @brands = "Tracking #{Brand.all.count} Brands"
  end
  
  def total_num_posts
    @posts = "Tracking #{Post.all.count} Posts"
  end
end
