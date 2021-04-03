keep = {
    "minecraft:diamond",
    "druidcraft:moonstone"
}

fuel = {
    "minecraft:coal",
    "druidcraft:fiery_glass"
}

function isInventoryFull()
    local isFull = true
    for slotIndex = 1, 16, 1
    do
        if turtle.getItemCount() == 0 then
            isFull = false
            break
        end
    end
    return isFull
end

function shouldKeepItem(item)
    for _, value in ipairs(keep) do
        if item.name == value then
            return true
        end
    end

    for _, value in ipairs(fuel) do
        if item.name == value then
            return true
        end
    end

    return false
end

function sortInventory()
    for slotIndex = 1, 16, 1
    do
        local item = turtle.getItemDetail(slotIndex)
        if item then
            if shouldKeepItem(item) == false then
                turtle.select(slotIndex)
                turtle.drop()
                turtle.select(1)
            end
        end
    end
end

sortInventory()

--while true do
--    sortInventory()
--
--    if isInventoryFull() then
--        break
--    end
--
--    turtle.dig()
--    sortInventory()
--
--    turtle.forward()
--
--    turtle.digUp()
--    sortInventory()
--end
