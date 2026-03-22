-- AutoJobs.lua
local myMod = ...
myMod:log("✅ AutoJobs.lua loaded")

local COMP_AUTO_JOBS = {
    TypeName = "COMP_AUTO_JOBS",
    ParentType = "COMPONENT",
    Properties = {}
}

-- Helper to get worker counts safely
local function safeGetWorkerCounts(workplaceComp)
    local workers, maxWorkers = 0, 0

    if workplaceComp.getWorkerCount then
        local ok, val = pcall(function() return workplaceComp:getWorkerCount() end)
        if ok and type(val) == "number" then workers = val end
    end

    if workplaceComp.getMaxWorkerCount then
        local ok, val = pcall(function() return workplaceComp:getMaxWorkerCount() end)
        if ok and type(val) == "number" then maxWorkers = val end
    end

    return workers, maxWorkers
end

-- Main daily job assignment
function COMP_AUTO_JOBS:onEnabled()
    myMod:log("AutoJobs: Component enabled")

    local compMainGameLoop = self:getLevel():find("COMP_MAIN_GAME_LOOP")
    if not compMainGameLoop then
        myMod:logError("AutoJobs: COMP_MAIN_GAME_LOOP not found!")
        return
    end

    event.register(self, compMainGameLoop.ON_NEW_DAY, function()
        local ok, err = pcall(function()
            local level = self:getLevel()
            if not level then
                myMod:logWarning("AutoJobs: Level missing, skipping day")
                return
            end

            local agentMgr = level:getComponentManager("COMP_AGENT")
            local workplaceMgr = level:getComponentManager("COMP_WORKPLACE")
            if not agentMgr or not workplaceMgr then
                myMod:logWarning("AutoJobs: Missing component managers")
                return
            end

            -- Collect agent components
            local agents = {}
            agentMgr:getAllEnabledComponent():forEach(function(agentComp)
                if agentComp then table.insert(agents, agentComp) end
            end)

            -- Collect workplaces
            local workplaces = {}
            workplaceMgr:getAllEnabledComponent():forEach(function(wc)
                if wc then table.insert(workplaces, wc) end
            end)

            myMod:log("AutoJobs: Found " .. #agents .. " agents and " .. #workplaces .. " workplaces")

            -- Identify unemployed villagers
            local unemployed = {}
            for _, agentComp in ipairs(agents) do
                if not agentComp.getEnabledComponent then
                    myMod:log("AutoJobs: Skipping agent (no getEnabledComponent)")
                    goto continue_agent
                end

                local owner = nil
                local okOwner, o = pcall(function() return agentComp:getOwner() end)
                if okOwner then owner = o end
                if not owner then goto continue_agent end

                -- Check if villager
                local villagerComp = nil
                local okV, vc = pcall(function() return owner:getEnabledComponent("COMP_VILLAGER") end)
                if okV and vc then villagerComp = vc end
                if not villagerComp then goto continue_agent end

                -- Check job status
                local jobComp = nil
                local okJ, jc = pcall(function() return owner:getEnabledComponent("COMP_JOB") end)
                if okJ and jc then jobComp = jc end

                local isUnemployed = false
                if not jobComp then
                    isUnemployed = true
                else
                    local hasWorkplace = false
                    if jobComp.Workplace and jobComp.Workplace ~= nil then hasWorkplace = true end
                    if jobComp.JobId and jobComp.JobId ~= "" then hasWorkplace = true end
                    if not hasWorkplace then isUnemployed = true end
                end

                if isUnemployed then
                    table.insert(unemployed, agentComp)
                end

                ::continue_agent::
            end

            myMod:log("AutoJobs: Found " .. #unemployed .. " unemployed villagers")

            -- Build open slots list
            local openSlots = {}
            for _, workplaceComp in ipairs(workplaces) do
                if not workplaceComp then goto continue_wc end

                local workers, maxWorkers = safeGetWorkerCounts(workplaceComp)
                local open = maxWorkers - workers
                if open > 0 then
                    for i = 1, open do
                        table.insert(openSlots, workplaceComp)
                    end
                    local wName = "(unknown)"
                    local okOwner, owner = pcall(function() return workplaceComp:getOwner() end)
                    if okOwner and owner and owner.Name then wName = owner.Name end
                    myMod:log("AutoJobs: Workplace '" .. wName .. "' has " .. workers .. "/" .. maxWorkers .. " workers -> " .. open .. " open slots")
                end

                ::continue_wc::
            end

            myMod:log("AutoJobs: Total open slots: " .. #openSlots)

            -- Assign unemployed to open slots
            local assigned = 0
            for i = 1, math.min(#unemployed, #openSlots) do
                local agentComp = unemployed[i]
                local workplaceComp = openSlots[i]

                if agentComp and workplaceComp and workplaceComp.registerVillager then
                    local okReg, rErr = pcall(function()
                        workplaceComp:registerVillager(agentComp)
                    end)
                    if okReg then
                        assigned = assigned + 1
                        local aName, wName = "(villager)", "(workplace)"
                        pcall(function() aName = agentComp:getOwner().Name end)
                        pcall(function() local o = workplaceComp:getOwner(); if o then wName = o.Name end end)
                        myMod:log("👷 AutoJobs: Assigned " .. aName .. " -> " .. wName)
                    else
                        myMod:logWarning("AutoJobs: Failed to register villager: " .. tostring(rErr))
                    end
                end
            end

            myMod:log("AutoJobs: Assignment complete. Assigned " .. assigned .. " villagers")
        end)

        if not ok then
            myMod:logError("AutoJobs: Fatal error during ON_NEW_DAY: " .. tostring(err))
        end
    end)

    myMod:log("AutoJobs: Registered to ON_NEW_DAY")
end

myMod:registerClass(COMP_AUTO_JOBS)
myMod:registerPrefabComponent("PREFAB_MANAGER", { DataType = "COMP_AUTO_JOBS", Enabled = true })
myMod:log("✅ AutoJobs component registered")
