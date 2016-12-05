module ApplicantsOverviewHelper
  def sort_caret(label, attr)
    is_sorted = params[:sort].to_s == attr.to_s

    "<a class=\"#{'dropup' if is_sorted}\" href=\"?sort=#{'-' if is_sorted}#{attr.to_s}\">
      #{label} <span class=\"caret\"></span>
    </a>".html_safe
  end
end

