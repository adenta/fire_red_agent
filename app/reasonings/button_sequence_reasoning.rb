class ButtonSequenceReasoning < BaseSchema
  def initialize
    super do
      enum :button, [
        Sky::KeyboardService::UP,
        Sky::KeyboardService::DOWN,
        Sky::KeyboardService::LEFT,
        Sky::KeyboardService::RIGHT,
        Sky::KeyboardService::A,
        Sky::KeyboardService::B
      ]
    end
  end
end
