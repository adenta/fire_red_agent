module Retroarch
  class KeyboardServiceLinux
    UP = :up
    DOWN = :down
    LEFT = :left
    RIGHT = :right
    A = :a
    B = :b

    KEY_CODES = {
      up: 'Up',
      down: 'Down',
      left: 'Left',
      right: 'Right',
      a: 'x',
      b: 'z'
    }.freeze

    APPLICATION_NAME = 'retroarch'

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
      ap "Sending button command: #{direction}"
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
      retries = 3
      begin
        ap "Activating application: #{APPLICATION_NAME}"
        result = system("xdotool search --name '#{APPLICATION_NAME}' windowactivate")
        ap 'xdotool failed to find or activate the window, continuing...' unless result
        sleep(1)
      rescue StandardError => e
        ap "Error activating application: #{e.message}"
        retries -= 1
        retry if retries > 0
        ap "Failed to activate application '#{APPLICATION_NAME}' after multiple attempts, continuing..."
      end
    end

    def self.key_down(key_code)
      ap "Key down: #{key_code}"
      system("xdotool keydown #{key_code}")
    end

    def self.key_up(key_code)
      ap "Key up: #{key_code}"
      system("xdotool keyup #{key_code}")
    end
  end
end
