class CreateMapMemories < ActiveRecord::Migration[8.0]
  def change
    create_table :map_memories do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end
