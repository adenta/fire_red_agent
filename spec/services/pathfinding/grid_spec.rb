require 'rails_helper'

RSpec.describe Pathfinding::Grid, type: :service do
  describe 'integration' do
    it 'returns the correct path' do
      raise NotImplementedError
      matrix = Locomotion::MapReader.fetch_map_cells
      grid = Pathfinding::Grid.new(matrix)
      player_location = Locomotion::MapReader.fetch_player_location

      start_node = grid.node(player_location[:x], player_location[:y])
      end_node = grid.node(player_location[:x] + 1, player_location[:y] + 1)

      # See what append if you change the arguments of the finder
      finder = Pathfinding::AStarFinder.new(Pathfinding::Heuristic.method(:manhattan))
      path = finder.find_path(start_node, end_node, grid)

      ap path

      charted_path = Pathfinding::Grid.chart_path(path)

      charted_path.each do |direction|
        Retroarch::KeyboardService.left if direction == 'left'
        Retroarch::KeyboardService.right if direction == 'right'
        Retroarch::KeyboardService.up if direction == 'up'
        Retroarch::KeyboardService.down if direction == 'down'
      end
    end
  end
end
