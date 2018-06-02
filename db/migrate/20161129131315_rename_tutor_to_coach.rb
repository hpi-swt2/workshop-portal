class RenameTutorToCoach < ActiveRecord::Migration[4.2]
  def up
    execute "UPDATE users SET role = 'coach' WHERE role = 'tutor'"
  end

  def down
    execute "UPDATE users SET role = 'tutor' WHERE role = 'coach'"
  end
end
