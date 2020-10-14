require('lib')

--will never mine, possibly causing the turtle to stop
_digBlacklist = {
        'diamond_ore',
        'emerald_ore',
        'quartz_ore',
        'stone_ore',
        'dawn_dusk_ore'
}

--will only mine if it is in the way of movement
_digMoveBlacklist = {
    'quartz_ore'
}

function digThree()
    ensureInventoryNotFull()
    --dealing with gravel
    while turtle.detect() do
        dig('f', _digMoveBlacklist)
        sleep(.5)
    end
    move('f')
    dig('u')
    dig('d')
end

--trash items handling with it's own table, only trash if has full stack, check if stacksize remaining is 0
--refill adjacent inventory when full on loop, may want user input before trying
--change read enter -> os.pullEvent('key')
--read timeout http://www.computercraft.info/forums2/index.php?/topic/5551-how-does-one-apply-a-timeout-to-read/
function placeTorch()
    if selectItem('minecraft:torch') then
        turtle.placeDown()
        return true
    else
        return false
    end
end

distance = askPositiveNumber('tunnel distance', arg[1])
if arg[2] == false then placeTorch = function () end end
move('u')
turn('l')
move('f')
turn('r')
goLeft = false
for i=1,distance do
    digThree()
    if goLeft then turn('l') else turn('r') end
    goLeft = not goLeft
    digThree()
    if i % 8 == 0 then placeTorch() end
    digThree()
    if goLeft then turn('l') else turn('r') end
end
if goLeft then turn('l') else turn('r') end
goLeft = not goLeft
move('f')
if goLeft then turn('l') else turn('r') end
move('d')
print('done')