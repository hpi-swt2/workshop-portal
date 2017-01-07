require 'redcarpet'
require 'redcarpet/render_strip'

# Very barebone "markdown" renderer that ignores all elements
# except paragraphs
class MarkdownRenderTruncate < Redcarpet::Render::Base
  def paragraph(text)
    text + ' '
  end

  def link(link, title, content)
    content
  end
end

module ApplicationHelper
  def menu_items
    (menu_item t(:events, scope: 'navbar'), events_path) +
    (menu_item t(:requests, scope: 'navbar'), requests_path)
  end

  # Render the given string as markdown
  #
  # @param text String containing markdown
  # @param truncatable boolean leave only paragraph elements
  # @return string html_safe rendered markdown
  def markdown(text, truncatable = false)
    renderer = truncatable ?
      MarkdownRenderTruncate.new :
      Redcarpet::Render::HTML.new({
        filter_html: true,
        hard_wrap: true,
        tables: true,
        strikethrough: true,
        link_attributes: { rel: 'nofollow', target: "_blank" },
        space_after_headers: true,
        fenced_code_blocks: true
      })

    Redcarpet::Markdown.new(renderer, {
      autolink: true,
      superscript: true,
      disable_indented_code_blocks: true
    }).render(text).html_safe
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
