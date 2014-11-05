class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :starred, null: false, default: false
      t.boolean :read, null: false, default: false

      t.timestamps
    end

    add_index :notes, :starred
    add_index :notes, :read
  end
end
