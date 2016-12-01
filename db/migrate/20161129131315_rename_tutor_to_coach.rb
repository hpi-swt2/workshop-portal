class RenameTutorToCoach < ActiveRecord::Migration
  def up
    execute "UPDATE users SET role = 'coach' WHERE role = 'tutor'"
  end

  def down
    execute "UPDATE users SET role = 'tutor' WHERE role = 'coach'"
  end
end
