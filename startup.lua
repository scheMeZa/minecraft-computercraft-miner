keep = {
    "minecraft:diamond",
    "druidcraft:moonstone"
}

fuel = {
    "minecraft:coal",
    "druidcraft:fiery_glass"
}

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

while true do
    if isInventoryFull() then break end
    if shouldRefuel() then refuel() end

    turtle.dig()
    sortInventory()
    turtle.turnRight()
    turtle.dig()
    sortInventory()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()
    sortInventory()
    turtle.turnRight()

    turtle.up()

    turtle.dig()
    sortInventory()
    turtle.turnRight()
    turtle.dig()
    sortInventory()
    turtle.turnLeft()
    turtle.turnLeft()
    turtle.dig()
    sortInventory()
    turtle.turnRight()

    turtle.down()

    turtle.forward()
end

print("My inventory is full! Mr. Stark, I don't feel so good...")