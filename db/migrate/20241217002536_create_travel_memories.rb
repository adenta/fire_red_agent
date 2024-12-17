class CreateTravelMemories < ActiveRecord::Migration[8.0]
  def change
    create_table :travel_memories do |t|
      t.integer :x, null: false
      t.integer :y, null: false
      t.string :script_name, null: false

      t.timestamps
    end
  end
end
