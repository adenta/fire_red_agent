require 'rails_helper'

RSpec.describe Pathfinding::Grid, type: :service do
  describe 'integration' do
    it 'returns the correct path' do
      matrix = Locomotion::MapReader.fetch_map_cells
      grid = Pathfinding::Grid.new(matrix)
      player_location = Locomotion::MapReader.fetch_player_location

      start_node = grid.node(player_location[:x], player_location[:y])
      end_node = grid.node(player_location[:x] + 1, player_location[:y] + 1)

      # See what append if you change the arguments of the finder
      finder = Pathfinding::AStarFinder.new(Pathfinding::Heuristic.method(:manhattan))
      path = finder.find_path(start_node, end_node, grid)

      ap path
    end
  end
end
