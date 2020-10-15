require('turtlelib')

--will never mine, possibly causing the turtle to stop
_digBlacklist = {
    'diamond_ore',
    'emerald_ore',
    'quartz_ore',
    'stone_ore',
    'dawn_dusk_ore',
    'computercraft'
}

--will only mine if it is in the way of movement
_digMoveBlacklist = {
    'quartz_ore'
}

local function digThree()
    ensureInventoryNotFull()
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
    },
    {
        name = 'width',
        default = 3,
        convert = tonumber,
        check = function(value) return type(value) == 'number' and value > 0 end,
        fail = 'width must be a number greater than 0'
    },
    {
        name = 'turnstartleft',
        default = false,
        convert = function(value)
            if value == 'true' then return true
            elseif value == 'false' then return false
            else error('turnstartleft must be \'true\' or \'false\'')
            end
        end
    }
}
local arg = progArgHandler(arg, handler)

local boolDirectedTurn
if arg.width == 1 then boolDirectedTurn = function () end
else
    boolDirectedTurn = function(turnLeft)
        if turnLeft then turn('l') else turn('r') end
        return not turnLeft
    end
end

local turnLeft = arg.turnstartleft
for currentDistance=1, arg.distance do
    digThree()
    turnLeft = boolDirectedTurn(turnLeft)
    for w=2,arg.width do digThree() end
    boolDirectedTurn(turnLeft)
end
