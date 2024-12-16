class ObjectEvent
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

  def to_s
    script_name = Game::SymbolReader.read_symbol(script)
    script_name ? script_name[:name] : 'Unknown Script'
  end
end
