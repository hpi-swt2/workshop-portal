class RenameDraftToPublished < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE 'events'
          SET draft = CASE draft WHEN 't' THEN 'f' ELSE 't' END;
        SQL
      end
      dir.down do
        execute <<-SQL
          UPDATE 'events'
          SET draft = CASE draft WHEN 't' THEN 'f' ELSE 't' END;
        SQL
      end
    end

    rename_column :events, :draft, :published
  end
end
