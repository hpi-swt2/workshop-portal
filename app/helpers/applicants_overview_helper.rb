module ApplicantsOverviewHelper
  def sort_caret(label, attr)
    is_sorted_ascending = (params[:sort] == attr.to_s) && params[:order] != 'descending'
    url = "?sort=#{attr.to_s}" +
      "#{'&order=descending' if is_sorted_ascending}" +
      "#{'&' + params[:filter].map { |k,v| "filter[#{k}]=#{v}" }.join('&') if params[:filter]}"

    "<a class=\"#{'dropup' if is_sorted_ascending}\" href=\"#{url}\">
      #{label} <span class=\"caret\"></span>
    </a>".html_safe
  end

  def sort_application_letters
    
    if params[:sort] && params[:sort] != 'applicant_age_when_event_starts' && params[:sort] != 'eating-habits'
      @application_letters.sort_by! {|l| l.user.profile.send(params[:sort]) } 
    end

    if params[:sort] && params[:sort] == 'applicant_age_when_event_starts' && params[:sort] != 'eating-habits'
      @application_letters.sort_by! {|l| l.send(params[:sort]) } 
    end

    @application_letters.reverse! if params[:order] == 'descending'
  
  end
end
