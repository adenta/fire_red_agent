# frozen_string_literal: true

module Game
  class PathNotFoundError < StandardError
    def initialize(msg = 'Path not found')
      super
    end
  end

  class Charter
    def self.list_destinations
      map_events = Game::EventReader.parse_map_events
      map_cells = Game::MapReader.fetch_map_cells
      # additional_warps = Game::EventReader.fetch_map_connection_warp_coords
      walkable_coordinates = Game::Charter.walkable_coordinates
      events = [*map_events.unified_events] # , *additional_warps]

      events.filter do |event|
        walkable_coordinates.include?([event.x, event.y])
      end.map do |event|
        {
          x: event.x,
          y: event.y,
          metatile_behavior: map_cells[event.y][event.x].metatile_behavior,
          description: event.to_s,
          type: event.class.name
        }
      end
    end

    def self.chart_path(destination)
      puts destination
      destination_x = destination[:x]
      destination_y = destination[:y]

      map_cells = Game::MapReader.fetch_map_cells

      grid = Pathfinding::Grid.new(map_cells)
      player_location = Game::MapReader.fetch_player_location

      start_node = grid.node(player_location[:x], player_location[:y])
      end_node = grid.node(destination_x, destination_y)

      puts grid.to_s(nil, start_node, end_node)

      puts start_node
      puts end_node

      if start_node.nil? || end_node.nil?
        Game::MemoryMaker.create_not_found_path_memory(destination_x, destination_y)
        raise PathNotFoundError
      end

      finder = Pathfinding::AStarFinder.new(Pathfinding::Heuristic.method(:manhattan))
      path = finder.find_path(start_node, end_node, grid)

      if path.nil?
        Game::MemoryMaker.create_not_found_path_memory(destination_x, destination_y)
        raise PathNotFoundError
      end

      # TODO(adenta) refactor this and the below cons into a unified method to do the dx dy logic
      if path.length == 1
        dx = destination_x - player_location[:x]
        dy = destination_y - player_location[:y]

        if dx == 1
          Retroarch::KeyboardService.right
        elsif dx == -1
          Retroarch::KeyboardService.left
        elsif dy == 1
          Retroarch::KeyboardService.down
        elsif dy == -1
          Retroarch::KeyboardService.up
        end
      end

      path.each_cons(2) do |node, next_node|
        break if Game::MapReader.in_battle?

        dx = next_node.x - node.x
        dy = next_node.y - node.y

        if dx == 1
          Retroarch::KeyboardService.right
        elsif dx == -1
          Retroarch::KeyboardService.left
        elsif dy == 1
          Retroarch::KeyboardService.down
        elsif dy == -1
          Retroarch::KeyboardService.up
        end
      end

      last_metatile_behavior = path.last.map_cell.metatile_behavior

      case last_metatile_behavior
      when Game::MetatileBehaviors::MB_DOWN_LEFT_STAIR_WARP
        Retroarch::KeyboardService.left
        Retroarch::KeyboardService.left
        Retroarch::KeyboardService.left

      when Game::MetatileBehaviors::MB_DOWN_RIGHT_STAIR_WARP
        Retroarch::KeyboardService.right
        Retroarch::KeyboardService.right
        Retroarch::KeyboardService.right

      when Game::MetatileBehaviors::MB_UP_LEFT_STAIR_WARP
        Retroarch::KeyboardService.left
        Retroarch::KeyboardService.left
        Retroarch::KeyboardService.left

      when Game::MetatileBehaviors::MB_UP_RIGHT_STAIR_WARP
        Retroarch::KeyboardService.right
        Retroarch::KeyboardService.right
        Retroarch::KeyboardService.right

      when Game::MetatileBehaviors::MB_EAST_ARROW_WARP
        Retroarch::KeyboardService.right
      when Game::MetatileBehaviors::MB_WEST_ARROW_WARP
        Retroarch::KeyboardService.left
      when Game::MetatileBehaviors::MB_NORTH_ARROW_WARP
        Retroarch::KeyboardService.up
      when Game::MetatileBehaviors::MB_SOUTH_ARROW_WARP
        Retroarch::KeyboardService.down
      end
    end

    def self.walkable_coordinates
      map_cells = Game::MapReader.fetch_map_cells

      grid = Pathfinding::Grid.new(map_cells)
      player_location = Game::MapReader.fetch_player_location

      start_node = grid.node(player_location[:x], player_location[:y])

      walkable_nodes = Pathfinding::AStarFinder.new.walkable_nodes(start_node, grid)

      walkable_nodes.map { |node| [node.x, node.y] }
    end

    def self.try_paths
      init_map_name = Game::MapReader.fetch_map_name
      ap 'trying a bunch of paths'
      Retroarch::KeyboardService.up
      Retroarch::KeyboardService.up
      sleep 1
      return if Game::MapReader.fetch_map_name != init_map_name

      Retroarch::KeyboardService.down
      Retroarch::KeyboardService.down
      Retroarch::KeyboardService.down
      Retroarch::KeyboardService.down
      sleep 1

      return if Game::MapReader.fetch_map_name != init_map_name

      Retroarch::KeyboardService.up
      Retroarch::KeyboardService.up
      Retroarch::KeyboardService.left
      Retroarch::KeyboardService.left
      sleep 1

      return if Game::MapReader.fetch_map_name != init_map_name

      Retroarch::KeyboardService.right
      Retroarch::KeyboardService.right
      Retroarch::KeyboardService.right
      Retroarch::KeyboardService.right
      sleep 1

      return if Game::MapReader.fetch_map_name != init_map_name

      Retroarch::KeyboardService.left
      Retroarch::KeyboardService.left
    end
  end
end
