class ButtonSequenceReasoning < BaseSchema
  def initialize
    super do
      enum :button, [
        Retroarch::KeyboardService::UP,
        Retroarch::KeyboardService::DOWN,
        Retroarch::KeyboardService::LEFT,
        Retroarch::KeyboardService::RIGHT,
        Retroarch::KeyboardService::A,
        Retroarch::KeyboardService::B
      ]
    end
  end
end
