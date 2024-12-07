module Locomotion
  G_BACKUP_MAP_DATA = 0x02031dfc
  G_BACKUP_MAP_DATA_LENGTH = 0x2800
  V_MAP = 0x03005040
  V_MAP_LENGTH = 12

  class MapReader
    def self.fetch_as_matrix
      memory_data = Retroarch::MemoryReader.read_bytes(G_BACKUP_MAP_DATA, G_BACKUP_MAP_DATA_LENGTH)

      # unsure why I need to multiply this by two
      row_size = fetch_map_dimensions[:map_width] * 2

      grid = memory_data.each_slice(row_size).to_a

      byte_grid = grid.map do |row|
        row.each_slice(2).to_a
      end

      byte_grid.map do |row|
        row.map do |pair|
          cell = pair.reverse.join

          binary_string = cell.to_i(16).to_s(2).rjust(16, '0').split('').reverse

          collision = [binary_string[10], binary_string[11]]

          case collision
          when %w[0 0]
            0
          when %w[0 1]
            1
          when %w[1 0]
            2
          when %w[1 1]
            3
          end
        end
      end
    end

    def self.fetch_as_text
      matrix = fetch_as_matrix

      matrix.map { |row| row.join }
    end

    def self.fetch_map_dimensions
      memory_data = Retroarch::MemoryReader.read_bytes(V_MAP, V_MAP_LENGTH)

      map_width, map_height, map_location = memory_data.each_slice(4).to_a

      map_width.reverse.join.to_i(16)

      {
        map_width: map_width.reverse.join.to_i(16),
        map_height: map_height.reverse.join.to_i(16)

      }
    end
  end
end
