namespace :red do
  task loop: :environment do
    loop do
      destinations = Game::Charter.list_destinations.to_json
      player_location = Game::MapReader.fetch_player_location.to_json
      collisions = Game::MapReader.fetch_colisions.to_json

      prompt = <<~PROMPT
        You are located on a grid at position #{player_location}.

        There are several destinations you can travel to:
        #{destinations}


        which of the destinations should you walk towards if you want to go outside? Always walk down stairs, never up stairs.

        You can only walk towards one of these given destinations, and nowhere else.
      PROMPT

      client = SchemaClient.new
      response_format = CharterReasoning.new
      response = client.parse(
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: prompt
          }
        ],
        response_format: response_format
      )

      x = response.parsed['x']
      y = response.parsed['y']

      Game::Charter.chart_path(x: x, y: y)
    end
  end

  task description: :environment do
    destinations = Game::Charter.list_destinations.to_json
    player_location = Game::MapReader.fetch_player_location.to_json

    prompt = <<~PROMPT
      You are located on a grid at position #{player_location}.

      There are several destinations you can travel to:
      #{destinations}.

      There are obsticles located at: #{collisions}

      You want to go outside. What is the next move you should take to go outside?
    PROMPT
  end

  task move: :environment do
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

    ap "Retroarch::KeyboardService::#{response.parsed['button'].upcase}".constantize
  end
end
