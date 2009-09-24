module SiteHelper

  def title title=nil, op_hash={}
    @page_title = ""
    @page_title += "#{title.to_s} | " if title
    @page_title = @page_title.titleize if op_hash[:titleize].nil?
    @page_title += "APPLICATION"
  end

  def place_fav_icon
    '<link rel="shortcut icon" href="/images/shared/icons/favicon.ico" type="image/x-icon"/>'+
      '<link rel="icon" href="/images/shared/icons/favicon.ico" type="image/x-icon"/>'
  end

  def include_ie_hacks
    html = "<!--[if IE 6]>"
    html << javascript_include_tag("IE7")
    html << stylesheet_link_tag("screen-ie")
    html << "<![endif]-->"
  end


  #options => {:extension => :png, :title => "Delete icon"}
  def icon_tag(icon_name, options={})
    options.reverse_merge!(:extension => :png)
    image_tag "icons/#{icon_name}.#{options[:extension]}", :title => options[:title], :alt => options[:title]
  end
  #options => {:extension => :png, :title => "Delete icon"}
  def icon_with_label(icon_name, caption, options={})
    html = icon_tag(icon_name, options)
    html << content_tag(:span, caption)
  end

  def link_to_void(caption, options={})
    link_to caption, "javascript:void(0)", options
  end

end
