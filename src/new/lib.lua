--[[
    attempts to get valueTable[index], if nil, then the function errors out
    typeOfIndex is merely an optional argument for helping debug by specifying that
        the type of index should be, for example, a direction
    if typeOfIndex is not entered, the error message will default to 'index' instead
    intended to be used for code error checking
]]
function getIndexOrError(valueTable, index, typeOfIndex)
    local value = valueTable[index]
    if typeOfIndex == nil then typeOfIndex = 'index' end
    if not value then error(typeOfIndex .. ' was not one of the options: ' .. index) end
    return value
end

--[[
    takes args passed into a program and returns a table pairing them together,
        the first arg with the second, the third with the fourth, etc
    for example, a program 'prog' called like so

    prog a 10 b 12 c hello

    would return a table that is analogous to

    {a = 10, b = 12, c = hello}


    optionally takes a handler object, which can specify:
        required args
        how to convert args
        how to check if an arg is valid
        what message to display if arg is invalid

    the following is an example handler with one arg specified
    (note: the handler passed in must be a table with a table within for each argument)

    {
        {
            name = 'distance',
            required = true,
            convert = tonumber,
            check = function(value) return type(value) == 'number' and value > 0 end,
            fail = 'distance must be a number greater than 0'
        },
        {
            name = 'width',
            convert = tonumber,
            check = function(value) return type(value) == 'number' and value > 0 end,
            fail = 'distance must be a number greater than 0'
            default = 3,
        }
    }

    name must be a string
    required is read as true or false, could technically be left out if
        false is desired as nil is also false, this function will error
        if required is true
    convert must be a function, which will be called with the argument
        specified as it's argument (in the first case, tonumber(distance) )
    check must be a function, and will be run on the result from convert,
        in these cases, check is ensuring that distance is a number, and that it
        is greater than 0
    fail is the message displayed if check returns false
        if required is true, then the function will error with that message
        if required is false, then the function will just print to inform the user
        if fail is left out the program will just inform the user that 'check failed
            for <name>'
    default is used in place of a user-entered arg when they did not
        enter one at all, or if the check failed
        in the case of check failure, the fail message is printed,
        as well as informing the user of the defaulting
]]
function progArgHandler(progArg, handler)
    if #progArg % 2 == 1 then error('progArguments length must be a multiple of 2') end
    handler = handler or {}
    local progArgTable = {}
    for i=1, #progArg, 2 do
        progArgTable[progArg[i]] = progArg[i + 1]
    end
    for _,v in ipairs(handler) do
        if progArgTable[v.name] then
            if v.convert then progArgTable[v.name] = v.convert(progArgTable[v.name]) end
            if v.check then
                if not v.check(progArgTable[v.name]) then
                    if v.required then
                        error(v.fail or 'check failed for ' .. v.name)
                    else
                        print(v.fail or 'check failed for ' .. v.name)
                        print(' defaulting to ' .. tostring(v.default))
                    end
                end
            end
        else
            if v.required then
                error('argument \'' .. v.name .. '\' is required but is not present')
            else
                progArgTable[v.name] = v.default
            end
        end
    end
    return progArgTable
end