# frozen_string_literal: true

#
# File: grid.rb
# Author: Quentin Deschamps
# Date: August 2020
#

module Pathfinding
  #
  # Represents the grid as a 2d-list of nodes.
  #
  class Grid
    include Enumerable

    #
    # Creates a grid from a matrix:
    # * 0 (or less) represents a walkable node
    # * A number greater than 0 does not represents a walkable node
    # The +width+ represents the number of columns whereas the +height+
    # is the number of rows of the grid. The +node+ attribute
    # is the list of nodes.
    #
    def initialize(matrix)
      @height = matrix.length
      @width = matrix[0].length
      @nodes = Pathfinding::Grid.build_nodes(@width, @height, matrix)
    end

    #
    # Gets the node at position (+x+, +y+).
    #
    def node(x, y)
      @nodes[y][x]
    end

    #
    # Yields all nodes of the grid.
    #
    def each_node
      @height.times do |y|
        @width.times do |x|
          yield node(x, y)
        end
      end
    end

    #
    # Creates a printable string from the grid using ASCII characters.
    # Params:
    # +path+:: list of nodes that show the path
    # +start_node+:: start node
    # +end_node+:: end node
    # +border+:: create a border around the grid
    # +start_chr+:: character for the start (default "s")
    # +end_chr+:: character for the end (default "e")
    # +path_chr+:: character for the path (default "x")
    # +empty_chr+:: character for the empty fields (default " ")
    # +block_chr+:: character for the blocking elements (default "#")
    #
    def to_s(
      path = nil, start_node = nil, end_node = nil, border = true,
      start_chr = 's', end_chr = 'e', path_chr = 'x', empty_chr = ' ', block_chr = '#'

    )
      data = []
      data << '+' + '-' * @width + '+' if border
      @height.times do |y|
        line = ''
        line += '|' if border
        @width.times do |x|
          current = node(x, y)
          line += if current == start_node
                    start_chr
                  elsif current == end_node
                    end_chr
                  elsif path&.include?(current)
                    path_chr
                  elsif current&.events&.any?
                    '!'
                  elsif current&.walkable?
                    empty_chr
                  else
                    block_chr
                  end
        end
        line += '|' if border
        data << line
      end
      data << '+' + '-' * @width + '+' if border
      data.join("\n")
    end

    #
    # Returns if the (+x+, +y+) position is in the grid.
    #
    def inside?(x, y)
      x >= 0 && x < @width && y >= 0 && y < @height
    end

    #
    # Returns if a node at position (+x+, +y+) is walkable.
    #
    def walkable?(x, y)
      inside?(x, y) && node(x, y).walkable?
    end

    #
    # Get all neighbors of a node.
    #
    def neighbors(node, end_node)
      x = node.x
      y = node.y
      neighbors = []
      s0 = d0 = s1 = d1 = s2 = d2 = s3 = d3 = false

      # ↑
      if walkable?(x, y - 1) || node(x, y - 1) == end_node
        neighbors << node(x, y - 1)
        s0 = true
      end

      # →
      if walkable?(x + 1, y) || node(x + 1, y) == end_node
        neighbors << node(x + 1, y)
        s1 = true
      end

      # ↓
      if walkable?(x, y + 1) || node(x, y + 1) == end_node
        neighbors << node(x, y + 1)
        s2 = true
      end

      # ←
      if walkable?(x - 1, y) || node(x - 1, y) == end_node
        neighbors << node(x - 1, y)
        s3 = true
      end

      neighbors
    end

    #
    # Builds and returns the nodes.
    #
    def self.build_nodes(width, height, matrix)
      nodes = []
      height.times do |y|
        nodes << []
        width.times do |x|
          map_cell = matrix[y][x]
          # raise "Map cell #{x}, #{y} cannot be nil!!" if map_cell.nil?

          nodes[y] << Node.new(x, y, map_cell)
        end
      end
      nodes
    end
  end
end
