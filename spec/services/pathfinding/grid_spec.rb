require 'rails_helper'

RSpec.describe Pathfinding::Grid, type: :service do
  describe 'integration' do
    it 'returns the correct path' do
      matrix = [
        [0, 0, 0],
        [0, 1, 0],
        [0, 0, 0]
      ]
      grid = Pathfinding::Grid.new(matrix)

      start_node = grid.node(0, 0)
      end_node = grid.node(2, 2)

      # See what append if you change the arguments of the finder
      finder = Pathfinding::AStarFinder.new(Pathfinding::Heuristic.method(:manhattan))
      path = finder.find_path(start_node, end_node, grid)

      ap path
    end
  end
end
