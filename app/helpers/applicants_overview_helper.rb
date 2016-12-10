module ApplicantsOverviewHelper
  def sort_caret(label, attr)
    is_sorted_ascending = (@sort.to_s == attr.to_s) && @order != 'descending'
    
    "<a class=\"#{'dropup' if is_sorted_ascending}\" href=\"?sort=#{attr.to_s}#{'&order=descending' if is_sorted_ascending}\">
      #{label} <span class=\"caret\"></span>
    </a>".html_safe
  end
end
