module Intelligence
  class LocomotionHandler
    def self.calculate_path
      destinations = Game::Charter.list_destinations.to_json
      player_location = Game::MapReader.fetch_player_location.to_json
      current_map_layout = Game::MapReader.fetch_map_name
      past_map_layouts = MapMemory.last(5).pluck(:name)

      prompt = <<~PROMPT
        You are located on a grid at position #{player_location}.

        You are currently located at map layout #{current_map_layout}.

        You have been to the following map layouts recently: #{past_map_layouts.join(', ')}.

        There are several destinations you can travel to:
        #{destinations}

        Here is a log of the previous places youve been and things you have interacted with:
        ```
         #{TravelMemory.all.to_json}
        ```

        Here is a log of your previous conversations so far:
        ```
        #{TextMemory.all.pluck(:body).join("\n")}
        ```

        You can only walk towards one of these given destinations, and nowhere else.

        Don't be afraid to walk towards the same space an object is currently standing on, we won't let you bump into them.

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
      x
      ap response.parsed

      TravelMemory.create!(x: x, y: y, script_name: description)

      Game::Charter.chart_path(x: x, y: y)

      { x: x, y: y }
    end
  end
end
