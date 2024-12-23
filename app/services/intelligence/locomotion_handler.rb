module Intelligence
  class LocomotionHandler
    def self.calculate_path
      destinations = Game::Charter.list_destinations.to_json
      player_location = Game::MapReader.fetch_player_location.to_json
      current_map_layout = Game::MapReader.fetch_map_name

      prompt = <<~PROMPT
        You are located on a grid at position #{player_location}.

        There are several destinations you can travel to:
        #{destinations}


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
      description = response.parsed['description']

      Game::Charter.chart_path(x: x, y: y)

      { x: x, y: y }
    end
  end
end
