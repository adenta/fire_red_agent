module Retroarch
  class SaveAndGameController
    def launch_emulator
      Async do |task|
        task.async do
          command = '/Applications/RetroArch.app/Contents/MacOS/RetroArch'
          system(command)
        end
      end
    end
  end
end
