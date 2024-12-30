module Intelligence
  class TextSummaryHandler
    def self.summerize_text
      prompt = <<~PROMPT
        Given the events that have happened so far, what should I be doing next? Write the response in first person.
      PROMPT

      client = OpenAI::Client.new
      response = client.chat(
        parameters: {
          model: 'gpt-4o',
          messages: [
            *OpenaiPromptBlueprint.render_as_hash(GameMemory.last(250)),
            {
              role: 'system',
              content: prompt
            }
          ]
        }
      )
      response['choices'][0]['message']['content']
    end
  end
end
