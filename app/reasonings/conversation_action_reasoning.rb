class ConversationActionReasoning < BaseSchema
  def initialize
    super do
      enum :next_action, %w[
        keep_talking
        move_on
      ]
      string :transcript, description: 'The text that is showing up on the screen.'
    end
  end
end
