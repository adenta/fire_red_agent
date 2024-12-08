# frozen_string_literal: true

#
# File: heuristic.rb
# Author: Quentin Deschamps
# Date: August 2020
#

#
# A collection of heuristic functions.
#
module Heuristic
  #
  # Manhattan distance.
  #
  def self.manhattan(dx, dy)
    dx + dy
  end

  #
  # Euclidean distance.
  #
  def self.euclidean(dx, dy)
    Math.sqrt(dx * dx + dy * dy)
  end

  #
  # Octile distance.
  #
  def self.octile(dx, dy)
    f = Math.sqrt(2) - 1
    dx < dy ? f * dx + dy : f * dy + dx
  end

  #
  # Chebyshev distance.
  #
  def self.chebyshev(dx, dy)
    [dx, dy].max
  end
end
