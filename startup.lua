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

function shouldKeepItem(item)
    for _, value in ipairs(keep) do
        if item.name == value then return true end
    end

    for _, value in ipairs(fuel) do
        if item.name == value then return true end
    end

    return false
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

while true do
    if isInventoryFull() then break end

    turtle.dig()
    sortInventory()

    turtle.forward()

    turtle.digUp()
    sortInventory()
end
