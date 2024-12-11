# frozen_string_literal: true

module Locomotion
  class PathNotFoundError < StandardError
    def initialize(msg = 'Path not found')
      super
    end
  end

  class Charter
    def self.list_destinations
      map_events = Locomotion::EventReader.parse_map_events

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

      events
    end

    def self.chart_path(destination)
      destination_x = destination[:x]
      destination_y = destination[:y]

      map_cells = Locomotion::MapReader.fetch_map_cells
      grid = Pathfinding::Grid.new(map_cells)
      player_location = Locomotion::MapReader.fetch_player_location

      start_node = grid.node(player_location[:x], player_location[:y])
      end_node = grid.node(destination_x, destination_y)

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
    end
  end
end
