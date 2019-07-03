local function init_global()
    global.fepp = {}
    global.fepp.allowed_buildings = {
        ['assembling-machine'] = true,
        ['lab'] = true
    }
end

local function on_init(event)
    init_global()
end
script.on_init(on_init)

local function on_configuration_changed(event)
    if not global.fepp then
        init_global()
    end
end
script.on_configuration_changed(on_configuration_changed)

local function on_build_handler(event)
    local entity = event.created_entity
    -- check against list of allowed entities
    if global.fepp.allowed_buildings[entity.prototype.type] then
        log(entity.name .. ' was built')
        local pos = entity.position
        local new_pos = entity.bounding_box.right_bottom
        --entity.surface.create_entity {name = 'fepp-pole', position = new_pos, force = entity.force}
        entity.surface.create_entity {name = 'fepp-pole', position = pos, force = entity.force}
    end

    -- place poles here.
end

script.on_event(defines.events.on_built_entity, on_build_handler)
script.on_event(defines.events.on_robot_built_entity, on_build_handler)

local function on_remove_handler(event)
    local entity = event.entity
    -- remove poles here.
    log(entity.name .. ' was removed')
    local pole_entities = entity.surface.find_entities_filtered({name = 'fepp-pole', area = entity.bounding_box})
    for i, pole in pairs(pole_entities) do
        -- game.print ('c position: '.. serpent.line (pole.position))
        pole.destroy()
    end
end

script.on_event(defines.events.on_pre_player_mined_item, on_remove_handler)
script.on_event(defines.events.on_robot_mined_entity, on_remove_handler)
