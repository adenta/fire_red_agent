class ObjectEventTemplate
  attr_accessor :local_id, :graphics_id, :kind, :x, :y,
                :elevation, :movement_type, :movement_range_x, :movement_range_y,
                :trainer_type, :trainer_range_berry_tree_id, :script, :flag_id,
                :target_local_id, :target_map_num, :target_map_group

  def initialize(local_id, graphics_id, kind, x, y,
                 elevation, movement_type, movement_range_x, movement_range_y,
                 trainer_type, trainer_range_berry_tree_id, script, flag_id,
                 target_local_id, target_map_num, target_map_group)
    @local_id = local_id
    @graphics_id = graphics_id
    @kind = kind
    @x = x
    @y = y
    @elevation = elevation
    @movement_type = movement_type
    @movement_range_x = movement_range_x
    @movement_range_y = movement_range_y
    @trainer_type = trainer_type
    @trainer_range_berry_tree_id = trainer_range_berry_tree_id
    @script = script
    @flag_id = flag_id
    @target_local_id = target_local_id
    @target_map_num = target_map_num
    @target_map_group = target_map_group
  end

  def object_event
    object_events = Game::ObjectEventReader.read_object_events

    object_events.map do |object_event|
      return object_event if object_event.local_id == local_id
    end

    nil
  end

  def x
    if object_event.present?
      object_event.current_coords.first
    else
      @x
    end
  end

  def y
    if object_event.present?
      object_event.current_coords.second
    else
      @y
    end
  end

  def on_map?
    object_event.present?
  end

  # def group_coords
  #   [
  #     local_id,
  #     object_event&.local_id
  #   ]
  # end

  # raise NotImplementedError

  # message = <<~HEREDOC
  #   (they also, annoyingly, don't clear gObjectEvents fully between map loads, which means you may find data from the previous map. They work around this by also comparing the mapNum and mapGroup fields to the expected values for the current map)
  #   adenta — Today at 6:44 PM
  #   this wouldve been incredibly confusing, 3 days from now. thank you 🙏
  # HEREDOC
  # ap message

  def to_s
    script_name = Game::SymbolReader.read_symbol(script)
    script_name ? script_name[:name] : 'Unknown Script'
  end
end
