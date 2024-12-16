class ConversationActionReasoning < BaseSchema
  def initialize
    super do
      enum :next_action, %w[
        keep_talking
        move_on
      ]
    end
  end
end
