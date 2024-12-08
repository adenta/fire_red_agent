# frozen_string_literal: true

#
# File: node.rb
# Author: Quentin Deschamps
# Date: August 2020
#

module Pathfinding
  #
  # Represents a node in the grid.
  #
  class Node
    # Gets the x coordinate in the grid.
    attr_reader :x

    # Gets the y coordinate in the grid.
    attr_reader :y

    #
    # Creates a node.
    #
    def initialize(x, y, map_cell)
      @x = x
      @y = y
      @map_cell = map_cell
    end

    def walkable?
      @map_cell.walkable?
    end

    #
    # Makes the string format of a node.
    #
    def to_s
      "(#{@x}, #{@y})"
    end
  end
end
