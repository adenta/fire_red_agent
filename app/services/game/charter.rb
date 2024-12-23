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

      events = map_events.unified_events

      events.map do |event|
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

      finder = Pathfinding::AStarFinder.new(Pathfinding::Heuristic.method(:manhattan))
      path = finder.find_path(start_node, end_node, grid)

      raise PathNotFoundError if path.nil?

      # TODO(adenta) refactor this and the below cons into a unified method to do the dx dy logic
      if path.length == 1
        dx = destination_x - player_location[:x]
        dy = destination_y - player_location[:y]

        if dx == 1
          Sky::KeyboardService.right
        elsif dx == -1
          Sky::KeyboardService.left
        elsif dy == 1
          Sky::KeyboardService.down
        elsif dy == -1
          Sky::KeyboardService.up
        end
      end

      path.each_cons(2) do |node, next_node|
        dx = next_node.x - node.x
        dy = next_node.y - node.y

        if dx == 1
          Sky::KeyboardService.right
        elsif dx == -1
          Sky::KeyboardService.left
        elsif dy == 1
          Sky::KeyboardService.down
        elsif dy == -1
          Sky::KeyboardService.up
        end
      end

      last_metatile_behavior = path.last.map_cell.metatile_behavior

      case last_metatile_behavior
      when Game::MetatileBehaviors::MB_DOWN_LEFT_STAIR_WARP
        Sky::KeyboardService.left
        Sky::KeyboardService.left
        Sky::KeyboardService.left

      when Game::MetatileBehaviors::MB_DOWN_RIGHT_STAIR_WARP
        Sky::KeyboardService.right
        Sky::KeyboardService.right
        Sky::KeyboardService.right

      when Game::MetatileBehaviors::MB_UP_LEFT_STAIR_WARP
        Sky::KeyboardService.left
        Sky::KeyboardService.left
        Sky::KeyboardService.left

      when Game::MetatileBehaviors::MB_UP_RIGHT_STAIR_WARP
        Sky::KeyboardService.right
        Sky::KeyboardService.right
        Sky::KeyboardService.right

      when Game::MetatileBehaviors::MB_EAST_ARROW_WARP
        Sky::KeyboardService.right
      when Game::MetatileBehaviors::MB_WEST_ARROW_WARP
        Sky::KeyboardService.left
      when Game::MetatileBehaviors::MB_NORTH_ARROW_WARP
        Sky::KeyboardService.up
      when Game::MetatileBehaviors::MB_SOUTH_ARROW_WARP
        Sky::KeyboardService.down
      end
    end
  end
end
