module BrandsHelper
  def format_websites(sites)
    text = ''
    site_arr = sites.split(/\r\n/)
    site_arr.each do |s|
      if s.start_with?("www")
        s.insert(0, 'http://')
      end
      if s.start_with?("http://")
        text << "#{link_to s, s, :target => '_blank'}<br>"
      end
    end
    text.html_safe
  end
end
