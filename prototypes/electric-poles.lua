if not data.raw['electric-pole']['medium-electric-pole'] then
    -- No pole to copy from. Error.
    error('The medium power pole has been removed from the game. Nothing to copy.')
end

local pole = table.deepcopy(data.raw['electric-pole']['medium-electric-pole'])

log(serpent.block(pole))

pole.name = 'fepp-pole'
pole.fast_replaceable_group = nil
pole.minable = nil
pole.flags = {
    'placeable-off-grid',
    'not-on-map'
}
--pole.draw_copper_wires = false
pole.maximum_wire_distance = 4
pole.supply_area_distance = 2.5
pole.selection_priority = 255


data:extend(
    {
        pole
    }
)

-- create embedded poles
local sizes = {
    [3] = true, -- Assembling Machine (Chem Plant, Centrifuge), Electric Furnace, Lab, Beacon (?)
    [5] = true, -- Refinery
    [9] = true -- Rocket Silo
}
for k, v in pairs(sizes) do
    -- statements
end
