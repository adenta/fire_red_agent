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

      events = []

      map_events.coord_events.each do |event|
        events << {
          x: event.x,
          y: event.y,
          type: 'coord_event',
          elevation: event.elevation,
          trigger: event.trigger,
          index: event.index,
          script: event.script
        }
      end

      map_events.bg_events.each do |event|
        events << {
          x: event.x,
          y: event.y,
          type: 'bg_event',
          elevation: event.elevation,
          kind: event.kind,
          hidden_item_or_script: event.hidden_item_or_script
        }
      end

      map_events.object_events.each do |event|
        events << {
          x: event.x,
          y: event.y,
          type: 'object_event',
          local_id: event.local_id,
          graphics_id: event.graphics_id,
          kind: event.kind,
          elevation: event.elevation,
          movement_type: event.movement_type,
          movement_range_x: event.movement_range_x,
          movement_range_y: event.movement_range_y,
          trainer_type: event.trainer_type,
          trainer_range_berry_tree_id: event.trainer_range_berry_tree_id,
          script: event.script,
          flag_id: event.flag_id,
          target_local_id: event.target_local_id,
          target_map_num: event.target_map_num,
          target_map_group: event.target_map_group
        }
      end

      map_events.warps.each do |event|
        events << {
          x: event.x,
          y: event.y,
          type: 'warp_event',
          elevation: event.elevation,
          warp_id: event.warp_id,
          map_num: event.map_num,
          map_group: event.map_group
        }
      end

      events.map do |event|
        {
          x: event[:x],
          y: event[:y],
          metatile_behavior: map_cells[event[:y]][event[:x]].metatile_behavior
        }
      end
    end

    def self.chart_path(destination)
      puts destination
      destination_x = destination[:x]
      destination_y = destination[:y]

      map_cells = Game::MapReader.fetch_map_cells

      grid = Pathfinding::Grid.new(map_cells)

      puts grid
      player_location = Game::MapReader.fetch_player_location

      start_node = grid.node(player_location[:x], player_location[:y])
      end_node = grid.node(destination_x, destination_y)

      puts start_node
      puts end_node

      finder = Pathfinding::AStarFinder.new(Pathfinding::Heuristic.method(:manhattan))
      path = finder.find_path(start_node, end_node, grid)

      raise PathNotFoundError if path.nil?

      path.each_cons(2) do |node, next_node|
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
  end
end
