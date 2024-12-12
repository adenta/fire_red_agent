namespace :red do
  desc 'Describe your task here'
  task description: :environment do
    # destinations = Locomotion::Charter.list_destinations.to_json

    client = SchemaClient.new
    response_format = ButtonSequenceReasoning.new
    response = client.parse(
      model: 'gpt-4o',
      messages: [
        {
          role: 'system',
          content: 'What is the konami code?'
        }
      ],
      response_format: response_format
    )

    ap response.parsed
  end
end
