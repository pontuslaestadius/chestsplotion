to_drop = {}
particles = {"copper-ore-particle", "wooden-particle", "iron-ore-particle"}

function angle(splash) return (math.random() - math.random()) / splash end

function on_tick()
    if #to_drop > 0 then
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
    end
end

function on_entity_died(event)
    local entity = event.entity
    local size = settings.global["chestsplotion-frequency"].value
    local splash = settings.global["chestsplotion-splash"].value
    for k, v in pairs(entity.get_output_inventory().get_contents()) do
        local pos = math.random(1, #to_drop + 1)
        table.insert(to_drop, pos, {
            name = particles[math.random(#particles)],
            surface = entity.surface,
            position = entity.position,
            itemstack = {name = k, count = size},
            movement = {angle(splash), angle(splash)},
            v = math.floor(v / (4 * size)) * size
        })
    end

end

script.on_event(defines.events.on_tick, on_tick)

script.on_event(defines.events.on_entity_died, on_entity_died, {
    LuaEntityDiedEventFilters = {filter = "type", type = "container"}
})
