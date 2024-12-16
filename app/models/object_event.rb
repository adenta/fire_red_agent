class ObjectEvent
  attr_accessor :active,
                :singleMovementActive,
                :triggerGroundEffectsOnMove,
                :triggerGroundEffectsOnStop,
                :disableCoveringGroundEffects,
                :landingJump,
                :heldMovementActive,
                :heldMovementFinished,
                :frozen,
                :facingDirectionLocked,
                :disableAnim,
                :enableAnim,
                :inanimate,
                :invisible,
                :offScreen,
                :trackedByCamera,
                :isPlayer,
                :hasReflection,
                :inShortGrass,
                :inShallowFlowingWater,
                :inSandPile,
                :inHotSprings,
                :hasShadow,
                :spriteAnimPausedBackup,
                :spriteAffineAnimPausedBackup,
                :disableJumpLandingGroundEffect,
                :fixedPriority,
                :hideReflection,
                :spriteId,
                :graphicsId,
                :movementType,
                :trainerType,
                :localId,
                :mapNum,
                :mapGroup,
                :currentElevation,
                :previousElevation,
                :initialCoords,
                :currentCoords,
                :previousCoords,
                :facingDirection,
                :movementDirection,
                :rangeX,
                :rangeY,
                :fieldEffectSpriteId,
                :warpArrowSpriteId,
                :movementActionId,
                :trainerRange_berryTreeId,
                :currentMetatileBehavior,
                :previousMetatileBehavior,
                :previousMovementDirection,
                :directionSequenceIndex,
                :playerCopyableMovement

  def self.from_bytes(bytes)
    bits = bytes[0, 4].to_s.unpack1('V')
    obj = new
    obj.active                     = (bits & (1 << 0)) != 0
    obj.singleMovementActive       = (bits & (1 << 1)) != 0
    obj.triggerGroundEffectsOnMove = (bits & (1 << 2)) != 0
    obj.triggerGroundEffectsOnStop = (bits & (1 << 3)) != 0
    obj.disableCoveringGroundEffects = (bits & (1 << 4)) != 0
    obj.landingJump               = (bits & (1 << 5)) != 0
    obj.heldMovementActive        = (bits & (1 << 6)) != 0
    obj.heldMovementFinished      = (bits & (1 << 7)) != 0
    obj.frozen                    = (bits & (1 << 8)) != 0
    obj.facingDirectionLocked     = (bits & (1 << 9)) != 0
    obj.disableAnim               = (bits & (1 << 10)) != 0
    obj.enableAnim                = (bits & (1 << 11)) != 0
    obj.inanimate                 = (bits & (1 << 12)) != 0
    obj.invisible                 = (bits & (1 << 13)) != 0
    obj.offScreen                 = (bits & (1 << 14)) != 0
    obj.trackedByCamera           = (bits & (1 << 15)) != 0
    obj.isPlayer                  = (bits & (1 << 16)) != 0
    obj.hasReflection             = (bits & (1 << 17)) != 0
    obj.inShortGrass              = (bits & (1 << 18)) != 0
    obj.inShallowFlowingWater     = (bits & (1 << 19)) != 0
    obj.inSandPile                = (bits & (1 << 20)) != 0
    obj.inHotSprings              = (bits & (1 << 21)) != 0
    obj.hasShadow                 = (bits & (1 << 22)) != 0
    obj.spriteAnimPausedBackup    = (bits & (1 << 23)) != 0
    obj.spriteAffineAnimPausedBackup = (bits & (1 << 24)) != 0
    obj.disableJumpLandingGroundEffect = (bits & (1 << 25)) != 0
    obj.fixedPriority             = (bits & (1 << 26)) != 0
    obj.hideReflection            = (bits & (1 << 27)) != 0

    obj.spriteId      = bytes[0x04].to_s.unpack1('C')
    obj.graphicsId    = bytes[0x05].to_s.unpack1('C')
    obj.movementType  = bytes[0x06].to_s.unpack1('C')
    obj.trainerType   = bytes[0x07].to_s.unpack1('C')
    obj.localId       = bytes[0x08].to_s.unpack1('C')
    obj.mapNum        = bytes[0x09].to_s.unpack1('C')
    obj.mapGroup      = bytes[0x0A].to_s.unpack1('C')

    elev_byte             = bytes[0x0B].to_s.unpack1('C')
    obj.currentElevation  = elev_byte & 0xF
    obj.previousElevation = elev_byte >> 4

    # Each Coords16 is 2 bytes (x) + 2 bytes (y)
    obj.initialCoords  = bytes[0x0C, 4].to_s.unpack('s<2') # little endian signed short
    obj.currentCoords  = bytes[0x10, 4].to_s.unpack('s<2')
    obj.previousCoords = bytes[0x14, 4].to_s.unpack('s<2')

    nibble = bytes[0x18, 2].to_s.unpack1('v') # 16 bits total
    obj.facingDirection = nibble & 0xF
    obj.movementDirection = (nibble >> 4) & 0xF
    obj.rangeX           = (nibble >> 8)  & 0xF
    obj.rangeY           = (nibble >> 12) & 0xF

    obj.fieldEffectSpriteId       = bytes[0x1A].to_s.unpack1('C')
    obj.warpArrowSpriteId         = bytes[0x1B].to_s.unpack1('C')
    obj.movementActionId          = bytes[0x1C].to_s.unpack1('C')
    obj.trainerRange_berryTreeId  = bytes[0x1D].to_s.unpack1('C')
    obj.currentMetatileBehavior   = bytes[0x1E].to_s.unpack1('C')
    obj.previousMetatileBehavior  = bytes[0x1F].to_s.unpack1('C')
    obj.previousMovementDirection = bytes[0x20].to_s.unpack1('C')
    obj.directionSequenceIndex    = bytes[0x21].to_s.unpack1('C')
    obj.playerCopyableMovement    = bytes[0x22].to_s.unpack1('C')

    obj
  end
end
