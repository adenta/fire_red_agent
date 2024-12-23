module Intelligence
  class ConversationHandler
    def self.handle_conversation
      text = []
      client = SchemaClient.new
      response_format = ConversationActionReasoning.new

      loop do
        sleep 1
        screenshot = Retroarch::ScreenshotReader.capture_screenshot
        prompt = <<~PROMPT
          You just started interacting with an object in pokemon. We need a transcript of the conversation.

          Text is going to show up on the screen.

          you need to keep talking until there is no more text on the screen.

          if you see text, we need to keep talking. if there is no text, we can move on.

          if you don't see any text on the screen, return an empty string.
        PROMPT

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
        transcript = response.parsed['transcript']

        text << transcript

        if transcript.present?
          ap "found text on screen: #{transcript}"
        else
          ap 'no text found on screen'
        end

        # Not deleting because we are gitignoreing, imagine data might be useful later
        # File.delete(screenshot[:file_path]) if File.exist?(screenshot[:file_path])

        break if next_action == 'move_on'

        Retroarch::KeyboardService.a
      end

      Game::MemoryMaker.create_screen_text_memory(text.join("\n")) unless text.compact.empty?
    end
  end
end
