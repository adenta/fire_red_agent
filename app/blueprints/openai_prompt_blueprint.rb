class OpenaiPromptBlueprint < Blueprinter::Base
  field :role do |game_memory|
    game_memory.memory_role
  end

  field :content do |game_memory|
    game_memory.body
  end
end
