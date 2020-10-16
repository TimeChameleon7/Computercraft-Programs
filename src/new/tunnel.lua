require('turtlelib')

--will never mine, possibly causing the turtle to stop
_digMoveBlacklist = {
    'diamond_ore',
    'emerald_ore',
    'quartz_ore',
    'stone_ore',
    'dawn_dusk_ore',
    'computercraft'
}

--will only mine if it is in the way of movement
_digBlacklist = {
    'quartz_ore'
}

local function fillShulkerBox()
    if select('shulker_box') then
        local placeAttempts = {
            {
                function () return place('u'), 'u' end,
                function () end
            }, {
                function () return place('f'), 'f' end,
                function () end
            }, {
                function () return place('d'), 'd' end,
                function () end
            }, {
                function () turn('l') return place('f'), 'f' end,
                function () turn('r') end
            }, {
                function () turn('l') return place('f'), 'f' end,
                function () turn('r', 2) end
            }, {
                function () turn('l') return place('f'), 'f' end,
                function () turn('l') end
            }
        }
        for _,v in ipairs(placeAttempts) do
            local pass, direction = v[1]()
            if pass then
                for slot=1,16 do
                    turtle.select(slot)
                    drop(direction)
                end
                dig(direction)
                v[2]()
                return
            end
        end
    end
end

local function digThree()
    if isInventoryFull() then
        fillShulkerBox()
        ensureInventoryNotFull()
    end
    --dealing with gravel
    while turtle.detect() do
        --can't use dig move, turtle will break the first gravel then get stuck
        dig('f', _digMoveBlacklist)
        sleep(.5)
    end
    move('f')
    dig('u')
    dig('d')
end

local handler = {
    {
        name = 'distance',
        required = true,
        convert = tonumber,
        check = function(value) return type(value) == 'number' and value > 0 end,
        fail = 'distance must be a number greater than 0'
    }, {
        name = 'width',
        default = 3,
        convert = tonumber,
        check = function(value) return type(value) == 'number' and value > 0 end,
        fail = 'width must be a number greater than 0'
    }, {
        name = 'direction',
        default = 'right',
        check = function (value) return value == 'right' or value == 'left' end,
        fail = 'direction must be either \'right\' or \'left\''
    }, {
        name = 'attended',
        default = true,
        convert = function (value)
            if value == 'true' then return true end
            if value == 'false' then return false end
        end,
        check = function (value) return type(value) == 'boolean' end,
        fail = 'attended must either be \'true\' or \'false\''
    }
}
local arg = progArgHandler(arg, handler)

if not arg.attended then
    _digBlacklist = _digMoveBlacklist
    _digMoveBlacklist = nil
end
local boolDirectedTurn
if arg.width == 1 then boolDirectedTurn = function () end
else
    boolDirectedTurn = function(turnLeft)
        if turnLeft then turn('l') else turn('r') end
        return not turnLeft
    end
end

local turnLeft = arg.direction == 'left'
for currentDistance=1, arg.distance do
    digThree()
    turnLeft = boolDirectedTurn(turnLeft)
    for w=2,arg.width do digThree() end
    boolDirectedTurn(turnLeft)
end