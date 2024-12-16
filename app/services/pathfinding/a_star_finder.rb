# frozen_string_literal: true

module Pathfinding
  class AStarFinder
    def initialize(
      heuristic = Pathfinding::Heuristic.method(:manhattan)
    )
      @heuristic = heuristic
    end

    def find_path(start_node, end_node, grid)
      pathfinding_helper(start_node, end_node, grid) || []
    end

    def find_closest_path(start_node, end_node, grid)
      path = pathfinding_helper(start_node, end_node, grid)
      return path if path

      # Find the nearest reachable node
      visited = {}
      open_set = [start_node]
      closest_node = start_node
      min_distance = @heuristic.call(
        (start_node.x - end_node.x).abs, (start_node.y - end_node.y).abs
      )

      until open_set.empty?
        current = open_set.shift
        visited[current] = true

        grid.neighbors(current).each do |neighbor|
          next if visited[neighbor]

          distance = @heuristic.call(
            (neighbor.x - end_node.x).abs, (neighbor.y - end_node.y).abs
          )
          if distance < min_distance
            closest_node = neighbor
            min_distance = distance
          end

          open_set << neighbor
        end
      end

      # Re-run pathfinding to the closest node
      path_to_closest = pathfinding_helper(start_node, closest_node, grid) || [start_node]

      # Add one final step if end_node is adjacent
      final_step = grid.neighbors(closest_node).find do |neighbor|
        neighbor.x == end_node.x && neighbor.y == end_node.y
      end
      if final_step
        path_to_closest << final_step
      else
        # If not directly adjacent, try a quick pathfinding attempt from closest_node to end_node
        extra_path = pathfinding_helper(closest_node, end_node, grid)
        path_to_closest.concat(extra_path[1..]) if extra_path && extra_path.size > 1
      end

      path_to_closest
    end

    private

    def pathfinding_helper(start_node, end_node, grid)
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
        (start_node.x - end_node.x).abs, (start_node.y - end_node.y).abs
      )

      until open_set.empty?
        current = open_set.min_by { |node| f_score[node] }
        return reconstruct_path(came_from, current) if current == end_node

        open_set.delete(current)
        grid.neighbors(current).each do |neighbor|
          tentative_g_score = g_score[current] + d(current, neighbor)
          next if tentative_g_score >= g_score[neighbor]

          came_from[neighbor] = current
          g_score[neighbor] = tentative_g_score
          f_score[neighbor] = tentative_g_score + @heuristic.call(
            (neighbor.x - end_node.x).abs, (neighbor.y - end_node.y).abs
          )
          open_set << neighbor unless open_set.include?(neighbor)
        end
      end

      nil
    end

    def d(n1, n2)
      n1.x == n2.x || n1.y == n2.y ? 1 : Math.sqrt(2)
    end

    def reconstruct_path(came_from, current)
      total_path = [current]
      while came_from.include?(current)
        current = came_from[current]
        total_path << current
      end
      total_path.reverse
    end
  end
end
