--[[
    follows water sources until none are remaining,
    mostly intended for usage after the area is already
    clear around them
    must start touching the water
    if not placed at the top of the water, may want to
    place directly under one of the highest sources
]]
require('turtlelib')

--technically going for lowest metadata, not highest, 0 is water source, increasing as you go further
local function faceHighestWater()
    if inspect('u').name:find('water') then return 'u' end
    local water = {}
    for i=1,4 do
        local block = inspect('f')
        if block.name:find('water') then
            if block.metadata == 0 then
                return 'f'
            else
                water[i] = block.metadata
            end
        end
        if i ~= 4 then turn('l') end
    end
    local lowestIndex, lowestValue
    for i=1,4 do
        if water[i] then
            if not lowestValue then
                lowestIndex = i
                lowestValue = water[i]
            elseif lowestValue > water[i] then
                lowestIndex = i
                lowestValue = water[i]
            end
        end
    end
    if not lowestValue then
        if inspect('d').name:find('water') then return 'd' end
        return
    end
    local switch = {
        function () turn('l') end,
        function () turn('r', 2) end,
        function () turn('r') end,
        function () end
    }
    switch[lowestIndex]()
    return 'f'
end

while true do
    local direction = faceHighestWater()
    if not direction then break end
    move(direction)
end