-- ForagerBoost.lua
local myMod = ...
myMod:log("✅ ForagerBoost.lua loaded")

local COMP_FORAGER_BOOST = {
    TypeName = "COMP_FORAGER_BOOST",
    ParentType = "COMPONENT",
    Properties = {
        { Name = "HarvestMultiplier", Type = "float", Default = 5.0 } -- Each bush gives x5 berries
    }
}

function COMP_FORAGER_BOOST:onEnabled()
    myMod:log("🍓 ForagerBoost enabled (x" .. tostring(self.HarvestMultiplier) .. " yield)")

    -- Find all forager components in the scene
    local compMgr = self:getLevel():getComponentManager("COMP_RESOURCE_PRODUCTION")
    if not compMgr then
        myMod:logError("ForagerBoost: Could not find COMP_RESOURCE_PRODUCTION manager")
        return
    end

    compMgr:getAllEnabledComponent():forEach(function(comp)
        if comp:getData():get("ResourceProduced") == "RESOURCE_BERRIES" then
            myMod:log("Boosting forager yield for: " .. tostring(comp:getOwner():getName()))
            
            -- Hook into onResourceProduced event (if it exists)
            if comp.onProduceResource then
                local oldFunc = comp.onProduceResource
                comp.onProduceResource = function(self, resource, amount)
                    if resource == "RESOURCE_BERRIES" then
                        amount = amount * myMod:getPrefab("PREFAB_FORAGER_BOOST").HarvestMultiplier
                    end
                    return oldFunc(self, resource, amount)
                end
            else
                -- If no event, attempt to override production rate directly
                local oldAmount = comp:getData():get("ProductionAmount")
                if oldAmount then
                    comp:getData():set("ProductionAmount", oldAmount * self.HarvestMultiplier)
                end
            end
        end
    end)
end

myMod:registerClass(COMP_FORAGER_BOOST)
myMod:registerPrefabComponent("PREFAB_MANAGER", {
    DataType = "COMP_FORAGER_BOOST",
    Enabled = true
})
myMod:log("✅ ForagerBoost component registered")
