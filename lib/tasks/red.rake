namespace :red do
  task loop: :environment do
    past_map_layouts = [Game::MapReader.fetch_map_header[:map_layout].to_s(16)]

    loop do
      destinations = Game::Charter.list_destinations.to_json
      player_location = Game::MapReader.fetch_player_location.to_json
      current_map_layout = Game::MapReader.fetch_map_header[:map_layout].to_s(16)

      past_map_layouts << current_map_layout unless past_map_layouts.last == current_map_layout

      prompt = <<~PROMPT
        You are located on a grid at position #{player_location}.

        You are currently located at map layout #{current_map_layout}. You have been to the following map layouts: #{past_map_layouts.join(', ')}.

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

  task launch_game: :environment do
    command = [
      '/Applications/RetroArch.app/Contents/MacOS/RetroArch',
      '-L "/Users/andrew/Library/Application Support/RetroArch/cores/mgba_libretro.dylib"',
      Rails.root.join('db', 'data', 'games', 'firered.gba').to_s,
      "--appendconfig=#{Rails.root.join('db', 'data', 'retroarch_config', 'live-savestate.cfg')}"
    ].join(' ')

    system(command)
    puts 'Game launched successfully'
  end
end
