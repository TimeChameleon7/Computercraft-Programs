while true do
    turtle.suckUp()
    if turtle.refuel() then
        turtle.dropDown()
        print(turtle.getFuelLevel())
    end
end
