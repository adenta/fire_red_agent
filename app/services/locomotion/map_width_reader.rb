module Locomotion
  V_MAP = 0x03005040
  V_MAP_LENGTH = 12

  class MapDimensionsReader
    def self.fetch
      memory_data = Retroarch::MemoryReader.read_bytes(V_MAP, V_MAP_LENGTH)

      map_width, map_height, map_location = memory_data.each_slice(4).to_a

      ap map_width
      ap map_height
    end
  end
end
