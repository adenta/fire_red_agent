module Retroarch
  class KeyboardService
    UP = :up
    DOWN = :down
    LEFT = :left
    RIGHT = :right
    A = :a
    B = :b

    KEY_CODES = {
      up: 126,
      down: 125,
      left: 123,
      right: 124,
      a: 0,
      b: 11
    }.freeze

    APPLICATION_NAME = 'RetroArch'

    def self.up
      send_key_event(:up)
    end

    def self.down
      send_key_event(:down)
    end

    def self.left
      send_key_event(:left)
    end

    def self.right
      send_key_event(:right)
    end

    def self.a
      send_key_event(:a)
    end

    def self.b
      send_key_event(:b)
    end

    def self.send_key_event(direction, duration = 0.01)
      ap "sending button command #{direction}"
      Async do |task|
        key_code = KEY_CODES[direction]
        raise ArgumentError, 'Invalid direction' unless key_code

        activate_application
        key_down(key_code)
        # task.sleep(duration)
        key_up(key_code)
      end
    end

    private

    def self.activate_application
      system("osascript -e 'tell application \"#{APPLICATION_NAME}\" to activate'")
      sleep(1)
    end

    def self.key_down(key_code)
      system("osascript -e 'tell application \"System Events\" to key down #{key_code}'")
    end

    def self.key_up(key_code)
      system("osascript -e 'tell application \"System Events\" to key up #{key_code}'")
    end
  end
end
