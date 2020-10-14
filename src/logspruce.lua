require('lib')

function digMoveDig(direction)
    dig(direction)
    move(direction)
    dig('f')
end

digMoveDig('f')

turtle.turnLeft()
isLogLeft = inspect('f', 'minecraft:log')
turtle.turnRight()

while inspect('u', 'minecraft:log') do
    digMoveDig('u')
end
digMoveDig('u')
if isLogLeft then
    turtle.turnLeft()
    dig('f')
    move('f')
    turtle.turnRight()
else
    turtle.turnRight()
    dig('f')
    move('f')
    turtle.turnLeft()
end
dig('f')
while inspect('d', 'minecraft:log') do--change to for iterator based on counted height
    digMoveDig('d')
end