if not data.raw['electric-pole']['medium-electric-pole'] then
    -- No pole to copy from. Error.
    error('The medium power pole has been removed from the game. Nothing to copy.')
end

local pole = table.deepcopy(data.raw['electric-pole']['medium-electric-pole'])
local pole2 = table.deepcopy(data.raw['electric-pole']['medium-electric-pole'])

--log(serpent.block(pole))

pole.minable = nil
pole.flags = {
    'placeable-off-grid',
    'not-on-map'
}
pole.maximum_wire_distance = 7.5
pole.fast_replaceable_group = nil

local circuit_pole = table.deepcopy(pole)
local power_pole = table.deepcopy(pole)

-- graphical pole at corner of machine
circuit_pole.name = 'fepp-circuit-pole'
circuit_pole.supply_area_distance = 0
circuit_pole.selection_priority = 255
circuit_pole.draw_copper_wires = true

power_pole.name = 'fepp-power-pole'
power_pole.selection_box = {{0, 0}, {0, 0}}
power_pole.draw_copper_wires = false
power_pole.supply_area_distance = 3.5
power_pole.selection_priority = 255



log(serpent.block(circuit_pole))
log(serpent.block(power_pole))

data:extend(
    {
        circuit_pole, power_pole
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
