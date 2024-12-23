module Game
  class MemoryMaker
    def self.create_location_memory
      player_location = Game::Charter.player_location
      game_role = GameMemory::ASSISTANT_ROLE
      body = <<~BODY
        You are located on a grid at position #{player_location} on map #{Game::MapReader.fetch_map_name}.
      BODY

      GameMemory.create!(game_role: game_role, body: body)
    end

    def self.create_destination_list_memory
      destinations = Game::Charter.list_destinations.to_json

      game_role = GameMemory::ASSISTANT_ROLE
      body = <<~BODY
        You can travel to one of the following destinations:
        #{destinations}

        You can only walk towards one of these given destinations, and nowhere else.
      BODY

      GameMemory.create!(game_role: game_role, body: body)
    end

    def self.create_chosen_location_memory(x, y, reasoning)
      game_role = GameMemory::USER_ROLE
      body = <<~BODY
        I am going to walk towards #{x}, #{y}. I'm doing this because #{reasoning}.
      BODY

      GameMemory.create!(game_role: game_role, body: body)
    end
  end
end
