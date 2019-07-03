local function init_global()
    global.fepp = {}
    global.fepp.allowed_buildings = {
        ['assembling-machine'] = true,
        ['lab'] = true,
        ['furnace'] = true
    }
end

-- entity: the entity at which to to place poles
local function place_poles(entity)
    --log(entity.name)
    --log(entity.prototype.type)
    --log(global.fepp.allowed_buildings[entity.prototype.type])


    -- check if it's a power pole.
    -- only allow connections to circuit-poles

    -- check against list of allowed entities
    if global.fepp.allowed_buildings[entity.prototype.type] then

        -- get entity size, adjust search radius
        local radius_to_search = math.ceil((math.ceil(entity.bounding_box.right_bottom.x) - math.floor(entity.bounding_box.left_top.x)) * 2)
        log('Radius: ' .. radius_to_search)

        local pos = entity.position
        local new_pos = {math.ceil(entity.bounding_box.right_bottom.x) - 0.5, math.ceil(entity.bounding_box.right_bottom.y) - 0.5}
        entity.surface.create_entity {name = 'fepp-circuit-pole', position = new_pos, force = entity.force}
        entity.surface.create_entity {name = 'fepp-power-pole', position = pos, force = entity.force}

        local power_pole = entity.surface.find_entities_filtered({name = {'fepp-power-pole'}, area = entity.bounding_box, limit = 1, force = entity.force})[1]
        local circuit_pole = entity.surface.find_entities_filtered({name = {'fepp-circuit-pole'}, area = entity.bounding_box, limit = 1, force = entity.force})[1]

        power_pole.disconnect_neighbour()
        circuit_pole.disconnect_neighbour()
        power_pole.connect_neighbour(circuit_pole)

        -- get all circuit poles in radius
        -- connect to closest (?)

        local neighbour_circuit_poles = entity.surface.find_entities_filtered({name = {'fepp-circuit-pole'}, position = entity.position, radius = radius_to_search, force = entity.force})
        for k, v in pairs (neighbour_circuit_poles) do
            -- statements
            circuit_pole.connect_neighbour(v)
        end
    end
end

local function remove_poles(entity)
    local pole_entities = entity.surface.find_entities_filtered({name = {'fepp-circuit-pole', 'fepp-power-pole'}, area = entity.bounding_box})
    for i, pole in pairs(pole_entities) do
        --game.print('Removing fepp-pole at position: ' .. serpent.line(pole.position))
        pole.destroy()
    end
end

local function on_init(event)
    init_global()
end
script.on_init(on_init)

local function on_configuration_changed(event)
    if not global.fepp then
        init_global()
    end

    --[[ Recreate Poles, just in case they've been changed by a version update ]]
    -- For Each Surface
    -- Get Poles
    -- For each Pole
    -- Get underlying entity
    -- Remove Pole
    -- Create new Pole

    for k, surface in pairs(game.surfaces) do
        local poles = surface.find_entities_filtered {name = 'fepp-circuit-pole'}
        for k, pole in pairs(poles) do
            local entities_at_position = surface.find_entities_filtered({position = pole.position})
            remove_poles(pole)
            for k, v in pairs(entities_at_position) do
                if v.valid then
                    log(v.name .. ' at position {' .. v.position.x .. ', ' .. v.position.y .. '}')
                    place_poles(v)
                end
            end
        end
    end
end
script.on_configuration_changed(on_configuration_changed)

local function on_build_handler(event)
    local entity = event.created_entity
    place_poles(entity)
end

script.on_event(defines.events.on_built_entity, on_build_handler)
script.on_event(defines.events.on_robot_built_entity, on_build_handler)

local function on_remove_handler(event)
    local entity = event.entity
    -- remove poles here.
    remove_poles(entity)
end

script.on_event(defines.events.on_pre_player_mined_item, on_remove_handler)
script.on_event(defines.events.on_robot_mined_entity, on_remove_handler)
