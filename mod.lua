-- mod.lua
local myMod = foundation.createMod()

local function safeLoad(file)
    local success, err = pcall(function()
        myMod:dofile(file)
    end)
    if success then
        myMod:log("Loaded module: " .. file)
    else
        myMod:logError("Failed to load module: " .. file .. " | Error: " .. tostring(err))
    end
end

-- Load modules safely
safeLoad("modules/AutoAcceptVillagers.lua")
safeLoad("modules/AutoJobs.lua")
safeLoad("modules/BetterBaker.lua")
safeLoad("modules/BetterFarms.lua")
safeLoad("modules/BetterFishing.lua")
safeLoad("modules/BetterLumberCamp.lua")
safeLoad("modules/BetterMill.lua")
safeLoad("modules/BetterPatrols.lua")
safeLoad("modules/BetterRoads.lua")
safeLoad("modules/BetterSawMill.lua")
safeLoad("modules/BoostImmigrants.lua")
safeLoad("modules/ForagerBoost.lua")