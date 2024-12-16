class CharterReasoning < BaseSchema
  def initialize
    super do
      string :explanation, description: 'Reason you are deciding to go to a specific location'
      number :x, description: 'The x-coordinate of the destination'
      number :y, description: 'The y-coordinate of the destination'
      # boolean :interact, description: 'Whether the player can interact with the destination'
    end
  end
end
