class CreateGameMemories < ActiveRecord::Migration[8.0]
  def change
    create_table :game_memories do |t|
      t.string :memory_role, null: false
      t.string :body, null: false

      t.timestamps
    end
  end
end
