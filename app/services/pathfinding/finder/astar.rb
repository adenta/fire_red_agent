# frozen_string_literal: true

#
# File: astar.rb
# Author: Quentin Deschamps
# Date: August 2020
#
require 'pathfinding/core/grid'
require 'pathfinding/core/diagonal_movement'
require 'pathfinding/core/heuristic'

#
# A* path-finder.
#
class AStarFinder
  #
  # Initializes the A* path-finder. Params:
  # * +heuristic+: heuristic function (see the +Heuristic+ module)
  # * +diagonal_movement+: set diagonal movements (see the +DiagonalMovement+ module)
  #
  def initialize(
    heuristic = Heuristic::method(:manhattan),
    diagonal_movement = DiagonalMovement::NEVER
  )
    @diagonal_movement = diagonal_movement
    if diagonal_movement == DiagonalMovement::NEVER
      @heuristic = heuristic
    else
      @heuristic = Heuristic::method(:octile)
    end
  end

  #
  # Finds and returns the path as a list of node objects.
  #
  def find_path(start_node, end_node, grid)
    open_set = [start_node]
    came_from = {}
    g_score = {}
    f_score = {}
    grid.each_node do |node|
      g_score[node] = Float::INFINITY
      f_score[node] = Float::INFINITY
    end
    g_score[start_node] = 0
    f_score[start_node] = @heuristic.call(
      (start_node.x - end_node.x).abs, (start_node.y - end_node.y).abs)

    until open_set.empty?
      current = open_set[0]
      open_set.each do |node|
        current = node if f_score[node] < f_score[current]
      end

      if current == end_node
        return reconstruct_path(came_from, current)
      end

      current = open_set.delete_at(open_set.index(current))

      grid.neighbors(current, @diagonal_movement).each do |neighbor|
        tentative_g_score = g_score[current] + d(current, neighbor)
        next if tentative_g_score >= g_score[neighbor]

        came_from[neighbor] = current
        g_score[neighbor] = tentative_g_score
        f_score[neighbor] = g_score[neighbor] + @heuristic.call(
          (neighbor.x - end_node.x).abs, (neighbor.y - end_node.y).abs)
        unless open_set.include?(neighbor)
          open_set << neighbor
        end
      end
    end
  end

  #
  # Returns the distance between two nodes.
  #
  def d(n1, n2)
    (n1.x == n2.x || n1.y == n2.y) ? 1 : Math.sqrt(2)
  end

  #
  # Reconstructs the path from the current node.
  #
  def reconstruct_path(came_from, current)
    total_path = [current]
    while came_from.include?(current)
      current = came_from[current]
      total_path << current
    end
    total_path.reverse
  end
end
