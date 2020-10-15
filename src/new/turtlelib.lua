require('lib')
--[[
    moves safely, meaning, that if a movement is blocked
    it will keep trying until it is no longer blocked.
]]
function move(direction)
    local moveTable = {
        u = turtle.up,
        d = turtle.down,
        f = turtle.forward,
        b = turtle.back
    }
    local moveCall = getIndexOrError(moveTable, direction, 'direction')
    refuel(1)
    repeat
        local success = moveCall()
    until success
end

function turn(direction, amount)
    amount = amount or 1
    local turnTable = {
        r = turtle.turnRight,
        l = turtle.turnLeft
    }
    local turnCall = getIndexOrError(turnTable, direction, 'direction')
    --I'm pretty sure turn can't fail, but better safe than sorry
    for i=1,amount do
        repeat
            local success = turnCall()
        until success
    end
end

--[[
    scans inventory for fuel, refueling to get above the threshold
    if there is no fuel, will print asking for fuel from a player
    will not return until fuel is above threshold
]]
function refuel(threshold)
    while turtle.getFuelLevel() < threshold do
        if not turtle.refuel(1) then
            local foundFuel = false
            for i=1,16 do
                turtle.select(i)
                if turtle.refuel(1) then
                    foundFuel = true
                    break
                end
            end
            if not foundFuel then
                write('fuel below threshold, enter after providing fuel to continue...')
                read()
            end
        end
    end
end

-- if inventory has no empty slots, will print informing the user that, and wait until it is fixed
function ensureInventoryNotFull()
    while isInventoryFull() do
        write('inventory full, enter after remedy to continue...')
        read()
    end
end

-- 'full' is defined by if any slots are empty, not absolutely full
function isInventoryFull()
    for i=1,16 do
        if turtle.getItemCount(i) == 0 then return false end
    end
    return true
end

--[[
    returns info about the block in the direction specified
    unlike turtle.inspect(), it will return data for
     minecraft:air if there is no block
]]
function inspect(direction)
    local inspectTable = {
        u = turtle.inspectUp,
        f = turtle.inspect,
        d = turtle.inspectDown
    }
    local b, info = getIndexOrError(inspectTable, direction, 'direction')()
    if not b then
        info = {
            metadata = 0,
            name = 'minecraft:air',
            state = {}
        }
    end
    return info
end

--[[
    compares the block in the direction specified to compareTo
    if compareTo is a table, returns exact match for metadata and
        name, state is not checked
    if compareTo is a string
        if isExact then returns the result of info.name == compareTo
        else returns the result of string.find(info.name, compareTo)
]]
function detect(direction, compareTo, isExact)
    local info = inspect(direction)
    if type(compareTo) == 'table' then
        return
            info.metadata == compareTo.metadata and
            info.name == compareTo.metadata
    elseif type(compareTo) == 'string' then
        if isExact then return info.name == compareTo
        else return string.find(info.name, compareTo) end
    else
        error('compareTo must be either a table or string, was of type ' .. type(compareTo))
    end
end

--[[
    attempts to select the item specified, returns true if successful
    if compareTo is a table, returns exact match for damage and
        name, count is not checked
    if compareTo is a string
        if isExact then returns the result of item.name == compareTo
        else returns the result of string.find(item.name, compareTo)
]]
function select(compareTo, isExact)
    local check
    if type(compareTo) == 'table' then
        check = function(item)
            return item.name == compareTo.name and
                    item.damage == compareTo.damage
        end
    elseif type(compareTo) == 'string' then
        if isExact then check = function(item) return item.name == compareTo end
        else check = function(item) return string.find(item.name, compareTo) end end
    else
        error('compareTo must be either a table or string, was of type ' .. type(compareTo))
    end
    local item = getItemDetail()
    if check(item) then return true end
    for slot=1,16 do
        item = getItemDetail(slot)
        if check(item) then
            turtle.select(slot)
            return true
        end
    end
    return false
end

--[[
    returns info about the item in the slot specified
        or the current selected slot if unspecified
    unlike turtle.getItemDetail(), it will return data for
        minecraft:air if there is no item
]]
function getItemDetail(slot)
    local item = turtle.getItemDetail(slot)
    if not item then
        item = {
            count = 0,
            damage = 0,
            name = 'minecraft:air'
        }
    end
    return item
end

--[[
    merges turtle.equipRight and turtle.equipLeft and changing the
        different sides to an argument
    returns true if successful in equipping
]]
function equip(side)
    local equipTable = {
        r = turtle.equipRight,
        l = turtle.equipLeft
    }
    return getIndexOrError(equipTable, side, 'side')()
end

function attack(direction)
    local attackTable = {
        u = turtle.attackUp,
        f = turtle.attack,
        d = turtle.attackDown
    }
    return getIndexOrError(attackTable, direction, 'direction')
end

--[[
    returns false if attempting to drop into a full inventory
]]
function drop(direction)
    local dropTable = {
        u = turtle.dropUp,
        f = turtle.drop,
        d = turtle.dropDown
    }
    return getIndexOrError(dropTable, direction, 'direction')()
end

--[[
    returns false if the turtle cannot pickup the item
]]
function suck(direction)
    local suckTable = {
        u = turtle.suckUp,
        f = turtle.suck,
        d = turtle.suckDown
    }
    return getIndexOrError(suckTable, direction, 'direction')()
end

--[[
    signText is optional
]]
function place(direction, signText)
    local placeTable = {
        u = turtle.placeUp,
        f = turtle.place,
        d = turtle.placeDown
    }
    return getIndexOrError(placeTable, direction, 'direction')(signText)
end

_digBlacklist = {}
--[[
    allows digging with a specified blacklist, if the thing attempting
    to be dug is blacklisted, returns blacklisted value if the dig attept
    hits a blacklisted item otherwise, returns the result of the turtle.dig call
]]
function dig(direction, blacklist)
    blacklist = blacklist or _digBlacklist
    local digTable = {
        ['u'] = turtle.digUp,
        ['f'] = turtle.dig,
        ['d'] = turtle.digDown
    }
    local digCall = digTable[direction]
    if digCall then
        local name = inspect(direction).name
        for _, value in pairs(blacklist) do
            if string.find(name, value) then
                return value
            end
        end
        return digCall()
    else
        error('direction was not one of the options: ' .. direction)
    end
end

_digMoveBlacklist = {}
--[[
    dig in the direction specified, if dig succeeds, will not return until move does
    returns blacklisted value if the dig attept hits a blacklisted item
    returns false if the dig fails
]]
function digMove(direction, blacklist)
    if blacklist == nil then blacklist = _digMoveBlacklist end
    local digReturn = dig(direction, blacklist)
    if digReturn == true then
        move(direction)
    else
        return digReturn
    end
end