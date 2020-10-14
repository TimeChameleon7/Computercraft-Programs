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
