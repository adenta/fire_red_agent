class TextReasoning < BaseSchema
  def initialize
    super do
      string :text, description: 'The text that is on the screen'
    end
  end
end
