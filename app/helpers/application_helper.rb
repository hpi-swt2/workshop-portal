module ApplicationHelper
  def menu_items
    (menu_item t(:home, scope: 'navbar'), root_path) +
    (menu_item t(:events, scope: 'navbar'), events_path) +
    (menu_item t(:requests, scope: 'navbar'), requests_path)
  end

  def dropdown_items
    o = ''
    o << (menu_item t(:settings, scope: 'navbar'), edit_user_registration_path)
    if current_user.profile.present? and current_user.role? :pupil
      o << (menu_item t(:profile, scope: 'navbar'), profile_path(current_user.profile))
    end
    if current_user.role? :pupil
      o << (menu_item t(:my_application_letters, scope: 'navbar'), application_letters_path)
    end
    o << (menu_item t(:logout, scope: 'navbar'), destroy_user_session_path, :method => :delete)
    o.html_safe
  end
end
