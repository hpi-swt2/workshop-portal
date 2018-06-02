class AddAnnotationToApplicationLetters < ActiveRecord::Migration[4.2]
  def change
    add_column :application_letters, :annotation, :text
  end
end
