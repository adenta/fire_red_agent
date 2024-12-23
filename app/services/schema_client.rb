# Client class for interacting with OpenAI API
require 'ostruct'

class SchemaClient
  def initialize
    @client = OpenAI::Client.new
  end

  # Send a request to OpenAI API and parse the response
  def parse(model:, messages:, response_format:, frequency_penalty: 0, presence_penalty: 0)
    response = @client.chat(
      parameters: {
        model:,
        messages:,
        frequency_penalty:,
        presence_penalty:,
        response_format: {
          type: 'json_schema',
          json_schema: response_format.to_hash
        }
      }
    )

    content = JSON.parse(response['choices'][0]['message']['content'])

    if response['choices'][0]['message']['refusal']
      OpenStruct.new(refusal: response['choices'][0]['message']['refusal'], parsed: nil)
    else
      OpenStruct.new(refusal: nil, parsed: content)
    end
  end
end
