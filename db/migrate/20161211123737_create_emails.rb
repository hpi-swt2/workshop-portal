class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.boolean :hide_recipients
      t.string :recipients
      t.string :reply_to
      t.string :subject
      t.string :content

      t.timestamps null: false
    end
  end
end
