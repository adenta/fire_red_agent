module Intelligence
  class LocomotionHandler
    def self.calculate_path
      prompt = <<~PROMPT
        You are a pokemon master, trying to determine where to go on the map next.
      PROMPT

      client = SchemaClient.new
      response_format = CharterReasoning.new
      response = client.parse(
        model: 'gpt-4o',
        messages: [
          *OpenaiPromptBlueprint.render_as_hash(GameMemory.all),
          {
            role: 'system',
            content: prompt
          }
        ],
        response_format: response_format
      )

      x = response.parsed['x']
      y = response.parsed['y']
      description = response.parsed['description']
      explanation = response.parsed['explanation']

      [x, y, description, explanation]
    end
  end
end
