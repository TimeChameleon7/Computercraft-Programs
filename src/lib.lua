

--returns a number that is at least 1 from the user, default input from args is accepted
function askPositiveNumber(name, arg)
    if arg then
        local input = tonumber(arg)
        if type(input) == 'number' then
            if input < 1 then
                print(name ..' must be at least 1.')
            else
                return input
            end
        else
            print(name .. ' must be a number.')
        end
    end
    while true do
        local input = tonumber(askInput(name))
        if type(input) == 'number' then
            if input < 1 then
                print(name .. ' must be at least 1.')
            else
                return input
            end
        else
            print(name .. ' must be a number.')
        end
    end
end

function askInput(name)
    write(name .. '? ')
    return read()
end