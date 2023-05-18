-- Import settings. Can be found in settings.lua
local settings = require("settings")

local inventory = peripheral.wrap(settings.INVENTORY_SIDE)

-- Checks if the attached inventory has all slots full
local function checkInventory()
    local items = inventory.list()
    if next(items) == nil then
        return false
    end
    for index, item in pairs(items) do
        local count = item.count
        local max_items = inventory.getItemLimit(index)
        if count < max_items then
            return false 
        end
    end
    return true
end

local function waitForExit()
    repeat
        local _,key = os.pullEvent("key")
    until key == settings.STOP_KEY
end

local function updater()
    while true do
        os.sleep(1)
        redstone.setOutput(settings.REDSTONE_OUTPUT_SIDE, checkInventory())
    end
end

parallel.waitForAny(updater, waitForExit)
print("Exiting program")
redstone.setOutput(settings.REDSTONE_OUTPUT_SIDE, false)