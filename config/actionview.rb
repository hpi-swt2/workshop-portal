require 'action_view'

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  html = %(<div class="has-error">#{html_tag}</div>).html_safe
