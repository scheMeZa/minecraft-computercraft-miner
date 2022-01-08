keep = {
    "minecraft:diamond",
    "minecraft:diamond_ore",
    "minecraft:iron_ore",
    "minecraft:gold_ore",
    "minecraft:deepslate_diamond_ore",
    "minecraft:deepslate_iron_ore",
    "minecraft:deepslate_gold_ore",
    "minecraft:deepslate_redstone_ore",
    "mysticalworld:amethyst",
    "mysticalworld:amethyst_ore",
    "mysticalworld:quicksilver_ore",
    "druidcraft:moonstone",
    "forbidden_arcanus:xpetrified_ore",
    "tetra:geode"
}

fuel = {
    "minecraft:coal",
    "minecraft:coal_ore",
    "druidcraft:fiery_glass",
    "druidcraft:fiery_glass_ore"
}

coordinates = {
    x = 0,
    y = 0,
    z = 0
}

lastLocation = {}

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

function isSoughtAfterBlock()
    local success, item = turtle.inspect()
    return success and (isWhitelistedItem(item) or isFuelItem(item))
end

function isSoughtAfterBlockUp()
    local success, item = turtle.inspectUp()
    return success and (isWhitelistedItem(item) or isFuelItem(item))
end

function isSoughtAfterBlockDown()
    local success, item = turtle.inspectDown()
    return success and (isWhitelistedItem(item) or isFuelItem(item))
end

function shouldDig()
    return isSoughtAfterBlock()
end

function shouldDigUp()
    local success, item = turtle.inspectUp()
    return success and (isWhitelistedItem(item) or isFuelItem(item))
end

function shouldDigDown()
    local success, item = turtle.inspectDown()
    return success and (isWhitelistedItem(item) or isFuelItem(item))
end

function turnLeft()
    turtle.turnLeft()

    if direction == "forward" then
        direction = "left"
    elseif direction == "right" then
        direction = "forward"
    elseif direction == "backward" then
        direction = "right"
    elseif direction == "left" then
        direction = "backward"
    end
end

function turnRight()
    turtle.turnRight()

    if direction == "forward" then
        direction = "right"
    elseif direction == "right" then
        direction = "backward"
    elseif direction == "backward" then
        direction = "left"
    elseif direction == "left" then
        direction = "forward"
    end
end

function updateName()
    os.setComputerLabel(coordinates.x .. " " .. coordinates.y .. " " .. coordinates.z .. " " .. direction)
end

function moveUp()
    turtle.up()
    coordinates.y = coordinates.y + 1
    updateName()
end

function moveDown()
    turtle.down()
    coordinates.y = coordinates.y - 1
    updateName()
end

function moveForward()
    local moved = turtle.forward()
    if not moved then return end
    if direction == "forward" then
        coordinates.z = coordinates.z + 1
    elseif direction == "right" then
        coordinates.x = coordinates.x + 1
    elseif direction == "left" then
        coordinates.x = coordinates.x - 1
    elseif direction == "backward" then
        coordinates.z = coordinates.z - 1
    end
    updateName()
end

function dig()
    turtle.dig()
    sortInventory()
end

function digUp()
    turtle.digUp()
    sortInventory()
end

function digDown()
    turtle.digDown()
    sortInventory()
end

function comeBack()
    -- TODO
    setDirection(lastLocation.direction)
end

function followBlocks()
    dig()
    moveForward()
    evaluate()
end

function followBlocksUp()
    digUp()
    moveUp()
    evaluate()
end

function followBlocksDown()
    digDown()
    moveDown()
    evaluate()
end

function evaluateForward()
    if isSoughtAfterBlock() then followBlocks() end
end

function evaluateRight()
    turnRight()
    if isSoughtAfterBlock() then followBlocks() end
    turnLeft()
end

function evaluateLeft()
    turnLeft()
    if isSoughtAfterBlock() then followBlocks() end
    turnRight()
end

function evaluateUp()
    if isSoughtAfterBlockUp() then followBlocksUp() end
end

function evaluateDown()
    if isSoughtAfterBlockDown() then followBlocksDown() end
end

function evaluate()
    evaluateForward()
    evaluateRight()
    evaluateLeft()
    evaluateDown()
    evaluateUp()
end

while true do
    if isInventoryFull() then print("My inventory is full! Mr. Stark, I don't feel so good...") break end
    if shouldRefuel() and hasNoFuel() then print("I'm outa fuel!") break end
    if shouldRefuel() then refuel() end
    evaluate()
    dig()
    moveUp()
    evaluate()
    dig()
    moveDown()
    moveForward()
end
