# frozen_string_literal: true

#
# File: diagonal_movement.rb
# Author: Quentin Deschamps
# Date: August 2020
#

module Pathfinding
  #
  # Constants to set diagonal movements.
  #
  module DiagonalMovement
    # Always accept diagonal movements.
    ALWAYS = 1

    # Never accept diagonal movements.
    NEVER = 2

    # Accept a diagonal movement if there is at most one obstacle.
    IF_AT_MOST_ONE_OBSTACLE = 3

    # Accept a diagonal movement only when there is no obstacle.
    ONLY_WHEN_NO_OBSTACLE = 4
  end
end
