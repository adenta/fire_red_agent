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

      map_events.coord_events.each do |event|
        puts "Coord Event - X: #{event.x}, Y: #{event.y}, Elevation: #{event.elevation}, Trigger: #{event.trigger}, Index: #{event.index}, Script: #{event.script}"
      end

      map_events.bg_events.each do |event|
        puts "BG Event - X: #{event.x}, Y: #{event.y}, Elevation: #{event.elevation}, Kind: #{event.kind}, Hidden Item or Script: #{event.hidden_item_or_script}"
      end

      map_events.object_events.each do |event|
        puts "Object Event - Local ID: #{event.local_id}, Graphics ID: #{event.graphics_id}, Kind: #{event.kind}, X: #{event.x}, Y: #{event.y}, Elevation: #{event.elevation}, Movement Type: #{event.movement_type}, Movement Range X: #{event.movement_range_x}, Movement Range Y: #{event.movement_range_y}, Trainer Type: #{event.trainer_type}, Trainer Range Berry Tree ID: #{event.trainer_range_berry_tree_id}, Script: #{event.script}, Flag ID: #{event.flag_id}, Target Local ID: #{event.target_local_id}, Target Map Num: #{event.target_map_num}, Target Map Group: #{event.target_map_group}"
      end

      map_events.warps.each do |event|
        puts "Warp Event - X: #{event.x}, Y: #{event.y}, Elevation: #{event.elevation}, Warp ID: #{event.warp_id}, Map Num: #{event.map_num}, Map Group: #{event.map_group}"
      end
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
