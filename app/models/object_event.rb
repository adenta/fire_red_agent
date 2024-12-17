class ObjectEvent
  attr_accessor :active,
                :single_movement_active,
                :trigger_ground_effects_on_move,
                :trigger_ground_effects_on_stop,
                :disable_covering_ground_effects,
                :landing_jump,
                :held_movement_active,
                :held_movement_finished,
                :frozen,
                :facing_direction_locked,
                :disable_anim,
                :enable_anim,
                :inanimate,
                :invisible,
                :off_screen,
                :tracked_by_camera,
                :is_player,
                :has_reflection,
                :in_short_grass,
                :in_shallow_flowing_water,
                :in_sand_pile,
                :in_hot_springs,
                :has_shadow,
                :sprite_anim_paused_backup,
                :sprite_affine_anim_paused_backup,
                :disable_jump_landing_ground_effect,
                :fixed_priority,
                :hide_reflection,
                :sprite_id,
                :graphics_id,
                :movement_type,
                :trainer_type,
                :local_id,
                :map_num,
                :map_group,
                :current_elevation,
                :previous_elevation,
                :initial_coords,
                :current_coords,
                :previous_coords,
                :facing_direction,
                :movement_direction,
                :range_x,
                :range_y,
                :field_effect_sprite_id,
                :warp_arrow_sprite_id,
                :movement_action_id,
                :trainer_range_berry_tree_id,
                :current_metatile_behavior,
                :previous_metatile_behavior,
                :previous_movement_direction,
                :direction_sequence_index,
                :player_copyable_movement

  def self.from_bytes(bytes)
    bits = bytes[0, 4].unpack1('V')
    obj = new
    obj.active                     = (bits & (1 << 0)) != 0
    obj.single_movement_active     = (bits & (1 << 1)) != 0
    obj.trigger_ground_effects_on_move = (bits & (1 << 2)) != 0
    obj.trigger_ground_effects_on_stop = (bits & (1 << 3)) != 0
    obj.disable_covering_ground_effects = (bits & (1 << 4)) != 0
    obj.landing_jump               = (bits & (1 << 5)) != 0
    obj.held_movement_active       = (bits & (1 << 6)) != 0
    obj.held_movement_finished     = (bits & (1 << 7)) != 0
    obj.frozen                     = (bits & (1 << 8)) != 0
    obj.facing_direction_locked    = (bits & (1 << 9)) != 0
    obj.disable_anim               = (bits & (1 << 10)) != 0
    obj.enable_anim                = (bits & (1 << 11)) != 0
    obj.inanimate                  = (bits & (1 << 12)) != 0
    obj.invisible                  = (bits & (1 << 13)) != 0
    obj.off_screen                 = (bits & (1 << 14)) != 0
    obj.tracked_by_camera          = (bits & (1 << 15)) != 0
    obj.is_player                  = (bits & (1 << 16)) != 0
    obj.has_reflection             = (bits & (1 << 17)) != 0
    obj.in_short_grass             = (bits & (1 << 18)) != 0
    obj.in_shallow_flowing_water   = (bits & (1 << 19)) != 0
    obj.in_sand_pile               = (bits & (1 << 20)) != 0
    obj.in_hot_springs             = (bits & (1 << 21)) != 0
    obj.has_shadow                 = (bits & (1 << 22)) != 0
    obj.sprite_anim_paused_backup  = (bits & (1 << 23)) != 0
    obj.sprite_affine_anim_paused_backup = (bits & (1 << 24)) != 0
    obj.disable_jump_landing_ground_effect = (bits & (1 << 25)) != 0
    obj.fixed_priority             = (bits & (1 << 26)) != 0
    obj.hide_reflection            = (bits & (1 << 27)) != 0

    obj.sprite_id      = bytes[0x04].unpack1('C')
    obj.graphics_id    = bytes[0x05].unpack1('C')
    obj.movement_type  = bytes[0x06].unpack1('C')
    obj.trainer_type   = bytes[0x07].unpack1('C')
    obj.local_id       = bytes[0x08].unpack1('C')
    obj.map_num        = bytes[0x09].unpack1('C')
    obj.map_group      = bytes[0x0A].unpack1('C')

    elev_byte = bytes[0x0B].unpack1('C')
    obj.current_elevation  = elev_byte & 0xF
    obj.previous_elevation = elev_byte >> 4

    # Each Coords16 is 2 bytes (x) + 2 bytes (y)
    obj.initial_coords  = bytes[0x0C, 4].unpack('s<2') # little endian signed short
    obj.current_coords  = bytes[0x10, 4].unpack('s<2')
    obj.previous_coords = bytes[0x14, 4].unpack('s<2')

    nibble = bytes[0x18, 2].unpack1('v') # 16 bits total
    obj.facing_direction = nibble & 0xF
    obj.movement_direction = (nibble >> 4) & 0xF
    obj.range_x           = (nibble >> 8)  & 0xF
    obj.range_y           = (nibble >> 12) & 0xF

    obj.field_effect_sprite_id       = bytes[0x1A].unpack1('C')
    obj.warp_arrow_sprite_id         = bytes[0x1B].unpack1('C')
    obj.movement_action_id           = bytes[0x1C].unpack1('C')
    obj.trainer_range_berry_tree_id  = bytes[0x1D].unpack1('C')
    obj.current_metatile_behavior    = bytes[0x1E].unpack1('C')
    obj.previous_metatile_behavior   = bytes[0x1F].unpack1('C')
    obj.previous_movement_direction  = bytes[0x20].unpack1('C')
    obj.direction_sequence_index     = bytes[0x21].unpack1('C')
    obj.player_copyable_movement     = bytes[0x22].unpack1('C')

    obj
  end
end
