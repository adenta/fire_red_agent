module Intelligence
  class BattleHandler
    # TODO(adenta) I bet if a battle lasts longer than x minutes, thats when we do down and rights
    def self.handle_battle
      start_time = Time.zone.now
      loop do
        sleep 1
        elapsed_time_seconds = (Time.zone.now - start_time).to_i
        break unless Game::MapReader.in_battle?

        ap 'In a battle, sending A'
        Retroarch::KeyboardService.a

        next if elapsed_time_seconds < 60

        # this is to account for if a move runs out of PP
        if rand < 0.5
          Retroarch::KeyboardService.left
        elsif rand < 0.5
          Retroarch::KeyboardService.down
        end
      end
    end
  end
end
