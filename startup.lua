keep = {
    "minecraft:diamond",
    "minecraft:iron_ore",
    "minecraft:gold_ore",
    "druidcraft:moonstone",
    "forbidden_arcanus:xpetrified_orb",
    "tetra:geode"
}

fuel = {
    "minecraft:coal",
    "druidcraft:fiery_glass"
}

coordinates = {
    x = 0,
    y = 0,
    z = 0
}

direction = "forward"

os.setComputerLabel("Hi! My name is Ax")

function isInventoryFull()
    for slotIndex = 1, 16, 1
    do
        if turtle.getItemCount(slotIndex) == 0 then return false end
    end
    return true
end

function isWhitelistedItem(item)
    for _, value in ipairs(keep) do
        if item.name == value then return true end
    end
    return false
end

function isFuelItem(item)
    for _, value in ipairs(fuel) do
        if item.name == value then return true end
    end
    return false
end

function shouldKeepItem(item)
    return isWhitelistedItem(item) or isFuelItem(item)
end

function dropItem(slotIndex)
    turtle.select(slotIndex)
    turtle.drop()
    turtle.select(1)
end

function sortInventory()
    for slotIndex = 1, 16, 1
    do
        local item = turtle.getItemDetail(slotIndex)
        if item then
            if shouldKeepItem(item) == false then dropItem(slotIndex) end
        end
    end
end

function shouldRefuel()
    return turtle.getFuelLevel() < 50
end

function hasFuel()
    for slotIndex = 1, 16, 1
    do
        local item = turtle.getItemDetail(slotIndex)
        if item and isFuelItem(item) then
            return true
        end
    end
    return false
end

function hasNoFuel()
    return not hasFuel()
end

function consumeFuel(slotIndex)
    turtle.select(slotIndex)
    turtle.refuel(1)
    turtle.select(1)
end

function refuel()
    for slotIndex = 1, 16, 1
    do
        local item = turtle.getItemDetail(slotIndex)
        if item then
            if isFuelItem(item) == true then return consumeFuel(slotIndex) end
        end
    end
end

function shouldDig()
    local success, item = turtle.inspect()
    return success and (isWhitelistedItem(item) or isFuelItem(item))
end

function turnLeft()
    turtle.turnLeft()

    if direction == "forward" then
        direction = "left"
    elseif direction == "right" then
        direction = "forward"
    elseif direction == "behind" then
        direction = "right"
    elseif direction == "left" then
        direction = "behind"
    end
end

function turnRight()
    turtle.turnRight()

    if direction == "forward" then
        direction = "right"
    elseif direction == "right" then
        direction = "behind"
    elseif direction == "behind" then
        direction = "left"
    elseif direction == "left" then
        direction = "forward"
    end
end

function moveUp()
    turtle.up()
    coordinates.y = coordinates.y + 1
end

function moveDown()
    turtle.down()
    coordinates.y = coordinates.y - 1
end

function moveForward()
    turtle.forward()
    coordinates.z = coordinates.z - 1
end

function evaluateForward()
    turtle.dig()
    sortInventory()
end

function evaluateRight()
    turnRight()
    if shouldDig() then
        turtle.dig()
        sortInventory()
    end
    turnLeft()
end

function evaluateLeft()
    turnLeft()
    if shouldDig() then
        turtle.dig()
        sortInventory()
    end
    turnRight()
end

while true do
    if isInventoryFull() then print("My inventory is full! Mr. Stark, I don't feel so good...") break end
    if shouldRefuel() and hasNoFuel() then print("I'm outa fuel!") break end
    if shouldRefuel() then refuel() end
    evaluateForward()
    evaluateRight()
    evaluateLeft()
    moveUp()
    evaluateForward()
    evaluateRight()
    evaluateLeft()
    moveDown()
    moveForward()
end
