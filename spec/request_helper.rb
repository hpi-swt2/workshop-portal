def login(user)
  post user_session_path, params: {'user[email]': user.email, 'user[password]': user.password}
  follow_redirect!
end