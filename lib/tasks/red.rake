namespace :red do
  task loop: :environment do
    previous_system_states = []
    loop do
      destinations = Locomotion::Charter.list_destinations.to_json
      player_location = Locomotion::MapReader.fetch_player_location.to_json
      collisions = Locomotion::MapReader.fetch_colisions.to_json

      prompt = <<~PROMPT
        You are located on a grid at position #{player_location}.

        There are several destinations you can travel to:
        #{destinations}


        There are obsticles located at: #{collisions}


        You want to go outside. What is the next move you should take to go outside?

        If you are standing on a tile that has a direction attached to it, you might need to take one more step in that direction (eg: MB_SOUTH_ARROW_WARP, take another step south. MB_UP_RIGHT_STAIR_WARP, take another step right.)
      PROMPT

      client = SchemaClient.new
      response_format = ButtonSequenceReasoning.new
      response = client.parse(
        model: 'gpt-4o',
        messages: [
          {
            role: 'system',
            content: prompt
          },
          *previous_system_states

        ],
        response_format: response_format
      )

      response_button = response.parsed['button'].to_sym

      previous_system_states << {
        role: 'user',
        content: <<~CONTENT
          destinations: #{destinations}
          player location : #{player_location}
          collisions: #{collisions}
          button that I picked: #{response.parsed['button']}
        CONTENT
      }

      Retroarch::KeyboardService.send_key_event(response_button)
    end
  end

  task description: :environment do
    destinations = Locomotion::Charter.list_destinations.to_json
    player_location = Locomotion::MapReader.fetch_player_location.to_json

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
