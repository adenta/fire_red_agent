# frozen_string_literal: true

module Locomotion
  class PathNotFoundError < StandardError
    def initialize(msg = 'Path not found')
      super
    end
  end

  class Charter
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
