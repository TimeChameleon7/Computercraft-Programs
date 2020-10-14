require('lib')

dig('f')
move('f')
local height = 0
while inspect('u', 'minecraft:log') do
    dig('u')
    move('u')
    height = height + 1
end

repeat
    move('d')
    height = height - 1
until height == 0
