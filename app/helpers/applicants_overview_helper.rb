module ApplicantsOverviewHelper
  def sort_caret(label, attr)
    is_sorted_ascending = (params[:sort] == attr.to_s) && params[:order] != 'descending'

    "<a class=\"#{'dropup' if is_sorted_ascending}\" href=\"?sort=#{attr.to_s}#{'&order=descending' if is_sorted_ascending}\">
      #{label} <span class=\"caret\"></span>
    </a>".html_safe
  end

  def sort_application_letters
    @application_letters.sort_by! {|l| l.user.profile.send(params[:sort]) } if params[:sort] && params[:sort] != 'applicant_age_when_event_starts'
    @application_letters.sort_by! {|l| l.send(params[:sort]) } if params[:sort] && params[:sort] == 'applicant_age_when_event_starts'
    @application_letters.reverse! if params[:order] == 'descending'
  end
end
