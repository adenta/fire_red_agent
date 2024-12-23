class Droptablesmem < ActiveRecord::Migration[8.0]
  def change
    drop_table :map_memories
    drop_table :text_memories
    drop_table :travel_memories
  end
end
