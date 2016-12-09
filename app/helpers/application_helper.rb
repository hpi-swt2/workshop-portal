module ApplicationHelper
  def menu_items
    (menu_item t(:home, scope: 'navbar'), root_path) +
    (menu_item t(:events, scope: 'navbar'), events_path) +
    (menu_item t(:requests, scope: 'navbar'), requests_path)
  end

  def dropdown_items
    o = ''
    # everyone gets settings
    o << (menu_item t(:settings, scope: 'navbar'), edit_user_registration_path)
    # everyone gets their profile, if it exists
    if current_user.profile.present?
      o << (menu_item t(:profile, scope: 'navbar'), profile_path(current_user.profile))
    else
      o << (menu_item t(:create_profile, scope: 'navbar'), new_profile_path)
    end
    # pupils get their applications
    if current_user.role == "pupil"
      o << (menu_item t(:my_application_letters, scope: 'navbar'), application_letters_path)
    end
    # admins get user management
    if current_user.role == "admin"
      o << (menu_item t(:user_management, scope: 'navbar'), profiles_path)
    end
    # everyone gets logout
    o << (menu_item t(:logout, scope: 'navbar'), destroy_user_session_path, :method => :delete)

    o.html_safe
  end
end
