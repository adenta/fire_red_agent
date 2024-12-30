module Intelligence
  class LocomotionHandler
    def self.calculate_path
      prompt = <<~PROMPT
        You are a pokemon master, trying to determine where to go on the map next. If it appears you tried to#{' '}
        go to a warp and nothing happens, consider trying a different warp. Many of the warps are labeled with an
        appropriate metatile_attribute. Whenever you enter a new room, be sure to talk to everyone first.#{' '}
        You can't always interact with everything just yet. For example, if you have previously interacted with a pokeball
        and nothing happened, you probably need to do something else before you can interact with it again.

        You can never, EVER repeat the same action that you just took. In general, try not to repeat actions.
      PROMPT

      client = SchemaClient.new
      response_format = CharterReasoning.new
      response = client.parse(
        model: 'gpt-4o',
        messages: [
          *OpenaiPromptBlueprint.render_as_hash(GameMemory.last(250)),
          {
            role: 'system',
            content: prompt
          }
        ],
        response_format: response_format,
        frequency_penalty: 1,
        presence_penalty: 1
      )

      x = response.parsed['x']
      y = response.parsed['y']
      description = response.parsed['description']
      explanation = response.parsed['explanation']

      [x, y, description, explanation]
    end
  end
end
