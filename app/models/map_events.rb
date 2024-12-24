class MapEvents
  attr_accessor :object_event_template_count, :warp_count, :coord_event_count, :bg_event_count,
                :object_event_templates, :warps, :coord_events, :bg_events

  def initialize(object_event_template_count, warp_count, coord_event_count, bg_event_count,
                 object_event_templates, warps, coord_events, bg_events)
    @object_event_template_count = object_event_template_count
    @warp_count = warp_count
    @coord_event_count = coord_event_count
    @bg_event_count = bg_event_count
    @object_event_templates = object_event_templates
    @warps = warps
    @coord_events = coord_events
    @bg_events = bg_events
  end

  def unified_events
    object_event_templates_on_map = object_event_templates.select(&:on_map?)
    object_event_templates_on_map + warps + coord_events + bg_events
  end
end
