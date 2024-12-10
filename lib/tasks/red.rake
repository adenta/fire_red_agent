namespace :red do
  desc 'Describe your task here'
  task description: :environment do
    map_events = Locomotion::EventReader.parse_map_events
    puts map_events.to_json
    puts Locomotion::MapReader.fetch_player_location.to_json
  end
end
