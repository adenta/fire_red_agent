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

    attr_reader :map_cell

    #
    # Creates a node.
    #
    def initialize(x, y, map_cell)
      @x = x
      @y = y
      @map_cell = map_cell

      # raise "Map cell cannot be nil. #{x},#{y} was defined without a map cell" if @map_cell.nil?
    end

    def events
      @map_cell.events
    rescue NoMethodError
      puts "Map cell is nil at #{@x}, #{@y}"
      []
    end

    def walkable?
      @map_cell.walkable?
    rescue NoMethodError
      puts "Map cell is nil at #{@x}, #{@y}"
      false
    end

    #
    # Makes the string format of a node.
    #
    def to_s
      "(#{@x}, #{@y})"
    end
  end
end
