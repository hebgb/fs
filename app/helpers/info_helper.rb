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
end
