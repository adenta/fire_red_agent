require 'async'
require 'async/barrier'
require 'socket'
require 'pathname'
require 'base64'

module Sky
  class ScreenshotReader
    def self.capture_screenshot
      ap 'WARNING:  this implementation is incomplete'
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
  end
end
