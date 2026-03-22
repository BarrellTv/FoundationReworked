local myMod = ...
myMod:log("✅ AutoAcceptVil.lua loaded")

local COMP_IMMIGRANTS_CONTROLLER = {
    TypeName = "COMP_IMMIGRANTS_CONTROLLER",
    ParentType = "COMPONENT",
    Properties = {}
}

local allVisitors = {}

local function containsValue(t, value)
    for _, entry in ipairs(t) do
        if entry.Visitor == value then
            -- myMod:log("Duplicate visitor: " .. tostring(value:getOwner().Name))
            return true
        end
    end
    -- myMod:log("New visitor: " .. tostring(value:getOwner().Name))
    return false
end

local function removeValueFromTable(t, value)
    for i, entry in ipairs(t) do
        if entry.Visitor == value then
            table.remove(t, i)
            -- myMod:log("Length list => " .. #t)
            break
        end
    end
end

function COMP_IMMIGRANTS_CONTROLLER:init()
    self.accept_sound = foundation.createData({ DataType = "GAME_ACTION_AUDIO", AudioEventList = {"play_sfx_ui_acceptNewVillager"}})
end


function COMP_IMMIGRANTS_CONTROLLER:onEnabled()
    self.gameAction = foundation.createData({ DataType = "GAME_ACTION_IMMIGRATE" })
    -- Daily cycle --
    local compMainGameLoop = self:getLevel():find("COMP_MAIN_GAME_LOOP")
    event.register(self, compMainGameLoop.ON_NEW_DAY, function()

        -- Loop on all visitors --
        self:getLevel():getComponentManager("COMP_VISITOR"):getAllEnabledComponent():forEach(
            function(compVisitor)
                local agentProfile = tostring(compVisitor:getOwner():getEnabledComponent("COMP_AGENT"):getProfile().ProfileNameGendered[3])
                if agentProfile == "NEWCOMER"then
                    if not containsValue(allVisitors, compVisitor) then
                        table.insert(allVisitors, { Visitor = compVisitor, EventRegistered = false })
                        -- myMod:log("Length list => " .. #allVisitors)
                    end
                end
            end
        )
        -- End Loop on all visitors --

        for i, entry in ipairs(allVisitors) do
            local compVisitor = entry.Visitor
            -- myMod:log("Visitor => " .. compVisitor:getOwner().Name .. " EventRegistered => " .. tostring(entry.EventRegistered))
            -- Event on arrived visitors --
            if compVisitor and not entry.EventRegistered then
                event.register(self, compVisitor.ON_ARRIVED, function()
                    -- Accept new comer --
                    local compAgent = compVisitor:getOwner():getEnabledComponent("COMP_AGENT")
                    -- myMod:log("Accepting visitor : " .. compVisitor:getOwner().Name)
                    self.gameAction:execute(self:getLevel(), compAgent)
                    -- End Accept new comer --
                    
                    -- Trigger accept sound --
                    self.accept_sound:execute(self:getLevel(), compMainGameLoop)
                    -- End trigger accept sound --
   
                    removeValueFromTable(allVisitors, compVisitor)
               end)
               entry.EventRegistered = true
            --    myMod:log("New Event => Registered !")
            -- else
            --     myMod:log("Event already registered. Skipping..")
            end
            -- End Event on arrived visitors --
        end
    end)
    -- End Daily cycle --
end


myMod:registerClass(COMP_IMMIGRANTS_CONTROLLER)

myMod:registerPrefabComponent(
    "PREFAB_MANAGER",
    {
        DataType = "COMP_IMMIGRANTS_CONTROLLER",
        Enabled = true
    }
)
