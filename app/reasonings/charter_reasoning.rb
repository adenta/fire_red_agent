class CharterReasoning < BaseSchema
  def initialize
    super do
      number :x, description: 'The x-coordinate of the destination'
      number :y, description: 'The y-coordinate of the destination'
    end
  end
end
