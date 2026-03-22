-- BoostImmigrants.lua
local myMod = ...
myMod:log("✅ BoostImmigrants.lua loaded")

local COMP_BOOST_IMMIGRANTS = {
    TypeName = "COMP_BOOST_IMMIGRANTS",
    ParentType = "COMPONENT",
    Properties = {
        { Name = "Amount", Type = "integer", Default = 15 } -- how many immigrant groups to add
    }
}

function COMP_BOOST_IMMIGRANTS:onEnabled()
    myMod:log("BoostImmigrants: Component enabled")

    local compMainGameLoop = self:getLevel():find("COMP_MAIN_GAME_LOOP")
    if not compMainGameLoop then
        myMod:logError("BoostImmigrants: Could not find COMP_MAIN_GAME_LOOP!")
        return
    end

    -- Each new day, spawn additional immigrant groups
    event.register(self, compMainGameLoop.ON_NEW_DAY, function()
        local success, err = pcall(function()
            local level = self:getLevel()
            local immigrantsControllerMgr = level:getComponentManager("COMP_IMMIGRANTS_CONTROLLER")
            if not immigrantsControllerMgr then
                myMod:logWarning("BoostImmigrants: No IMMIGRANTS_CONTROLLER manager found")
                return
            end

            immigrantsControllerMgr:getAllEnabledComponent():forEach(function(controller)
                local visitAction = foundation.createData({
                    Type = "GAME_ACTION_VISIT",
                    VisitorCount = 1,
                    DaysAtDestination = 7,
                    VisitorPurpose = INTERACTIVE_LOCATION_PURPOSE.VISIT
                })

                if not visitAction then
                    myMod:logWarning("BoostImmigrants: Could not create GAME_ACTION_VISIT")
                    return
                end

                for i = 1, self.Amount do
                    controller:triggerImmigrantSpawn(visitAction)
                end
            end)

            myMod:log("BoostImmigrants: Spawned " .. tostring(self.Amount) .. " additional immigrants!")
        end)

        if not success then
            myMod:logError("❌ BoostImmigrants error: " .. tostring(err))
        end
    end)

    myMod:log("BoostImmigrants: Registered ON_NEW_DAY event")
end

myMod:registerClass(COMP_BOOST_IMMIGRANTS)
myMod:registerPrefabComponent("PREFAB_MANAGER", { DataType = "COMP_BOOST_IMMIGRANTS", Enabled = true })
myMod:log("✅ BoostImmigrants component registered")
