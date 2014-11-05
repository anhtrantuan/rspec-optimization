class AddFullTextSearchIndexToNotes < ActiveRecord::Migration
  def up
    execute "CREATE INDEX notes_title ON notes USING GIN(to_tsvector('english', title))"
    execute "CREATE INDEX notes_content ON notes USING GIN(to_tsvector('english', content))"
  end

  def down
    execute 'DROP INDEX notes_title'
    execute 'DROP INDEX notes_content'
  end
end
