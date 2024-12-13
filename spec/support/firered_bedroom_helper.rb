module FireredBedroomHelper
  def self.start_retroarch
    command = [
      '/Applications/RetroArch.app/Contents/MacOS/RetroArch',
      '-L "/Users/andrew/Library/Application Support/RetroArch/cores/mgba_libretro.dylib"',
      Rails.root.join('db', 'data', 'games', 'firered.gba').to_s,
      "--appendconfig=#{Rails.root.join('db', 'data', 'retroarch_config', 'bedroom-savestate.cfg')}"
    ].join(' ')

    @pid = spawn(command, out: '/dev/null', err: '/dev/null') # Redirects stdout and stderr
    Process.detach(@pid) # Detaches the process
    sleep(2) # Wait for initialization, adjust as necessary
  end

  def self.stop_retroarch
    return unless @pid

    Process.kill('KILL', @pid) # Sends the kill signal
    begin
      Process.wait(@pid)
    rescue Errno::ECHILD
      # No child process to wait for
    end

    state_file = Rails.root.join('db', 'data', 'saves', 'mGBA', 'firered.state')
    auto_state_file = Rails.root.join('db', 'data', 'saves', 'mGBA', 'firered.state.auto')

    # File.delete(state_file) if File.exist?(state_file)
    # File.delete(auto_state_file) if File.exist?(auto_state_file)
  end
end

RSpec.configure do |config|
  config.before(:each) do
    FireredBedroomHelper.start_retroarch
  end

  config.after(:each) do
    FireredBedroomHelper.stop_retroarch
  end
end
