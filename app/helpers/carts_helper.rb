module CartsHelper
	def badge_link_to(label, count, path)
    link_to "#{label} <span class='badge'>#{count}</span>".html_safe, path
  end
end
