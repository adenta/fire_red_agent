require 'async'
require 'async/barrier'
require 'socket'
require 'pathname'
require 'base64'

module Retroarch
  class ScreenshotReader
    def self.capture_screenshot
      send_screenshot_request
      # TODO(adenta) Find a better way to wait for the screenshot to be taken

      sleep 1
      screenshot_name = most_recent_screenshot_name
      screenshot_data = File.read(Rails.root.join(screenshot_name))

      # TODO(adenta) this can probably be compressed
      {
        data_url: "data:image/png;base64,#{Base64.strict_encode64(screenshot_data)}",
        file_path: Rails.root.join(screenshot_name)
      }
    end

    private

    def self.most_recent_screenshot_name
      # Define the path to the screenshots directory
      screenshots_dir = Pathname.new('tmp')

      # Get all .png files in the directory
      png_files = screenshots_dir.glob('*.png')

      # Sort files by their modification time (most recent last)
      sorted_files = png_files.sort_by { |file| file.mtime }

      # Get the most recent screenshot
      most_recent_file = sorted_files.last

      raise FileNotFoundError, 'No screenshot found' unless most_recent_file

      most_recent_file
    end

    def self.send_screenshot_request
      message = 'SCREENSHOT'
      udp_socket = UDPSocket.new

      # Send the message
      udp_socket.send(message, 0, '127.0.0.1', 55_355)

      udp_socket.close
    end
  end
end
