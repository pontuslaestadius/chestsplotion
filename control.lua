to_drop = {}
size = 4
splash = 7
particles = {"copper-ore-particle", "wooden-particle", "iron-ore-particle"}

script.on_event(defines.events.on_tick, function()
    for k, v in pairs(to_drop) do
        for i = v.v, 1, -v.itemstack.count do
            v.surface.spill_item_stack(v.position, v.itemstack)
            v.surface.create_particle {
                name = v.name,
                position = v.position,
                movement = v.movement,
                height = 0.3,
                vertical_speed = 0.15,
                frame_speed = 0.001
            }
        end
        table.remove(to_drop, k)
        return
    end
end)

script.on_event(defines.events.on_entity_died, function(event)
    for k, v in pairs(event.entity.get_output_inventory().get_contents()) do
        local pos = math.random(1, #to_drop + 1)
        table.insert(to_drop, pos, {
            name = particles[math.random(#particles)],
            surface = event.entity.surface,
            position = event.entity.position,
            itemstack = {name = k, count = size},
            movement = {
                (math.random() - math.random()) / splash,
                (math.random() - math.random()) / splash
            },
            v = math.floor(v / (10 * size)) * size
        })
    end
end, {LuaEntityDiedEventFilters = {filter = "type", type = "container"}})
