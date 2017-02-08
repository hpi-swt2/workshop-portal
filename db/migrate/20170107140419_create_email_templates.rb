class CreateEmailTemplates < ActiveRecord::Migration
  def change
    create_table :'email_templates.rb' do |t|
      t.integer :status
      t.string :subject
      t.text :content
      t.boolean :hide_recipients
    end
  end
end
