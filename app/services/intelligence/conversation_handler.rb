module Intelligence
  class ConversationHandler
    def self.handle_conversation
      screenshot = Retroarch::ScreenshotReader.capture_screenshot
      prompt = <<~PROMPT
        You just started interacting with an object in pokemon.

        Text is going to show up on the screen.

        if there is a red triangle you need to keep the conversation going by pressing a.

        if you don't see any text on the screen, press b
      PROMPT

      client = SchemaClient.new
      response_format = ConversationActionReasoning.new
      response = client.parse(
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: prompt
          },
          {
            role: 'user',
            content: [
              { "type": 'image_url',
                "image_url": {
                  "url": screenshot[:data_url]
                } }
            ]
          }
        ],
        response_format: response_format
      )

      next_action = response.parsed['next_action']

      File.delete(screenshot[:file_path]) if File.exist?(screenshot[:file_path])

      if next_action == 'keep_talking'
        Retroarch::KeyboardService.a
        handle_conversation
      elsif next_action == 'move_on'
        ap 'finished'
      end
    end
  end
end
