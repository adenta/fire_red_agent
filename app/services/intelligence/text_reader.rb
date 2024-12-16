module Intelligence
  class TextReader
    def self.read_text
      client = SchemaClient.new
      response_format = TextReasoning.new
      response = client.parse(
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: 'You are a video game photographer. You are tasked with reading the text from the screenshot. if no text is present, return an empty string. If the text is illegible, return an empty string. if the text is in a non english language, return an empty string'
          },
          {
            role: 'user',
            content: [
              { "type": 'image_url',
                "image_url": {
                  "url": Retroarch::ScreenshotReader.capture_screenshot
                } }
            ]
          }
        ],
        response_format: response_format
      )

      response.parsed['text']
    end
  end
end
