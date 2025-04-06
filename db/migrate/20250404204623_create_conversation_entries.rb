class CreateConversationEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :conversation_entries do |t|
      t.references :project, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :entryable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
