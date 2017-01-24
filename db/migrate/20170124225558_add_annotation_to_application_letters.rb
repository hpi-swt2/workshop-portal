class AddAnnotationToApplicationLetters < ActiveRecord::Migration
  def change
    add_column :application_letters, :annotation, :string
  end
end
