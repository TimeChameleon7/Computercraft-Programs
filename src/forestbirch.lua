require('lib')

--[[
follows blocks matching the name, breaking them as it goes
returns false when no more are found
returns true if returnName is found
]]
function follow(name, returnName)
    local inspectTable = {
        [1] = function () return {'f', inspect('f')} end,
        [2] = function () return {'d', inspect('d')} end,
        [3] = function () return {'u', inspect('u')} end,
        [4] = function () turn('r') return {'f', inspect('f')} end,
        [5] = function () turn('r') return {'f', inspect('f')} end,
        [6] = function () turn('r') return {'f', inspect('f')} end,
        [7] = function () turn('r') return false end
    }
    while true do
        for i=1,7 do
            local funTable = inspectTable[i]()
            print(funTable)
            if funTable then
                local direction = funTable[1]
                local info = funTable[2]
                if info.name == name then dig(direction) move(direction) break end
                if info.name == returnName then return true end
            else
                return false
            end
        end
    end
end

local name = askInput('follow block full name')
repeat
    shell.run('logbirch')
until not follow(name, 'minecraft:log')
print('done')