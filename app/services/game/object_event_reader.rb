module Game
  class ObjectEventReader
    OBJECT_EVENT_POINTER = 0x02036E38
    EVENT_SIZE = 0x24
    EVENT_COUNT = 16 # 0x240 / 0x24 = 16

    def self.read_object_events
      memory = Retroarch::MemoryReader.read_binary_bytes(OBJECT_EVENT_POINTER, EVENT_SIZE * EVENT_COUNT)
      (0...EVENT_COUNT).map do |i|
        ObjectEvent.from_bytes(memory[i * EVENT_SIZE, EVENT_SIZE])
      end
    end
  end
end
