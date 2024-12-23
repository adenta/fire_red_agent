module Game
  class MemoryMaker
    def self.create_location_memory
      player_location = Game::MapReader.fetch_player_location
      memory_role = GameMemory::ASSISTANT_ROLE
      body = <<~BODY
        You are located on a grid at position #{player_location} on map #{Game::MapReader.fetch_map_name}.
      BODY

      GameMemory.create!(memory_role: memory_role, body: body)
    end

    def self.create_destination_list_memory
      destinations = Game::Charter.list_destinations.to_json

      memory_role = GameMemory::ASSISTANT_ROLE
      body = <<~BODY
        You can travel to one of the following destinations:
        #{destinations}

        You can only walk towards one of these given destinations, and nowhere else.
      BODY

      GameMemory.create!(memory_role: memory_role, body: body)
    end

    def self.create_chosen_location_memory(x, y, description, explanation)
      memory_role = GameMemory::USER_ROLE
      body = <<~BODY
        I am going to walk towards #{x}, #{y} (#{description}). I'm doing this because #{explanation}.
      BODY

      GameMemory.create!(memory_role: memory_role, body: body)
    end
  end
end
