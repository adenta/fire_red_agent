# frozen_string_literal: true

#
# File: node.rb
# Author: Quentin Deschamps
# Date: August 2020
#

#
# Represents a node in the grid.
#
class Node
  # Gets the x coordinate in the grid.
  attr_reader :x

  # Gets the y coordinate in the grid.
  attr_reader :y

  # Gets whether the node is walkable.
  attr_reader :walkable

  #
  # Creates a node.
  #
  def initialize(x, y, walkable = true)
    @x = x
    @y = y
    @walkable = walkable
  end

  #
  # Makes the string format of a node.
  #
  def to_s
    "(#{@x}, #{@y})"
  end
end
