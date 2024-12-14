module Game
  class TileReader
    def self.fetch_metatile_behaviors
      primary_memory_data = Retroarch::MemoryReader.read_binary_bytes(MapReader.tileset_metas[:primary_tileset][:metatile_attributes],
                                                                      MAX_METATILE_ATTRIBUTE_LENGTH)

      primary_behaviors = primary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      secondary_memory_data = Retroarch::MemoryReader.read_binary_bytes(MapReader.tileset_metas[:secondary_tileset][:metatile_attributes],
                                                                        MAX_METATILE_ATTRIBUTE_LENGTH)

      secondary_behaviors = secondary_memory_data.unpack('L<*').map do |raw|
        (raw & 0x1FF).to_s(16)
      end

      primary_behaviors + secondary_behaviors
    end
  end
end
