# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def current_controller?(url)
    url.gsub!(%r(http://[^/]*/), '/')
    url_hash = ActionController::Routing::Routes.recognize_path(url, :method => :get)
    url_hash[:controller] == params[:controller]
  end  
  
  def lorem(count)
    Faker::Lorem.paragraphs(count).collect { |text| content_tag(:p, text)}.join("\n")
  end 
  
end
