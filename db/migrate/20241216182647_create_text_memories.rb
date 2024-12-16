class CreateTextMemories < ActiveRecord::Migration[8.0]
  def change
    create_table :text_memories do |t|
      t.string :body, null: false

      t.timestamps
    end
  end
end
