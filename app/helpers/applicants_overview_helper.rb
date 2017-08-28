module ApplicantsOverviewHelper
  def sort_caret(label, attr)
    is_sorted_ascending = (params[:sort] == attr.to_s) && params[:order] != 'descending'
    url = "?sort=#{attr}" \
          "#{'&order=descending' if is_sorted_ascending}" \
          "#{'&' + params[:filter].map { |k, v| "filter[#{h(k)}]=#{h(v)}" }.join('&') if params[:filter]}"

    "<a class=\"#{'dropup' if is_sorted_ascending}\" href=\"#{url}\">
      #{label} <span class=\"caret\"></span>
    </a>".html_safe
  end

  def sort_application_letters
    if params[:sort]
      if Profile.allowed_sort_methods.include? params[:sort].to_sym
        @application_letters.sort_by! { |l| l.user.profile.send(params[:sort]) }
      else
        raise CanCan::AccessDenied
      end
    end

    @application_letters.reverse! if params[:order] == 'descending'
  end
end
