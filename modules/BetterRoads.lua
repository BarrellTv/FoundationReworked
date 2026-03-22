local myMod = ...
myMod:log("✅ BetterRoads.lua loaded")

-- Try to find the paved road manager asset safely
local roadManager = foundation.findAsset("DEFAULT_PAVED_ROAD_MANAGER_SETTINGS")

if not roadManager then
    myMod:logError("❌ BetterRoads: Could not find DEFAULT_PAVED_ROAD_MANAGER_SETTINGS asset!")
    return
end

-- Check if TimeBeforeDowngrade exists
if not roadManager.TimeBeforeDowngrade then
    myMod:logWarning("BetterRoads: TimeBeforeDowngrade is nil, creating new TIME_SYSTEM object")
    roadManager.TimeBeforeDowngrade = foundation.createData({
        Type = "TIME_SYSTEM",
        Time = 0.0,
        TypeValue = TIME_SYSTEM_TYPE.MONTHS
    })
end

-- Print current value
if roadManager.TimeBeforeDowngrade and roadManager.TimeBeforeDowngrade.Time then
    myMod:log("BetterRoads: Current TimeBeforeDowngrade.Time = " .. tostring(roadManager.TimeBeforeDowngrade.Time))
else
    myMod:logWarning("BetterRoads: Could not read TimeBeforeDowngrade.Time")
end

-- Apply changes safely
local timeSys = roadManager.TimeBeforeDowngrade
if timeSys and type(timeSys.Time) == "number" then
    timeSys.Time = 12000.0 -- 1000 years in months
    myMod:log("BetterRoads: Updated TimeBeforeDowngrade.Time to " .. tostring(timeSys.Time))
end

if timeSys then
    timeSys.Type = TIME_SYSTEM_TYPE.MONTHS
    myMod:log("BetterRoads: Updated TimeBeforeDowngrade.Type to MONTHS")
end

-- Adjust downgrade influence
roadManager.RoadDowngradeTimePercentageWeightValue = 1000.0
myMod:log("BetterRoads: RoadDowngradeTimePercentageWeightValue set to 1000.0")

-- Keep dirt roads worse
roadManager.UnpavedRoadWeightValue = 25.0

-- Max paving per cycle
roadManager.MaxSegmentPavingPerCycle = 10

-- Cost adjustment
local cps = roadManager.CostPerRoadSegment
if cps and cps.forEach then
    cps:forEach(function(cost)
        if cost and cost.Quantity then
            cost.Quantity = cost.Quantity * 0.5
        end
    end)
else
    myMod:log("BetterRoads: CostPerRoadSegment not iterable (userdata without forEach)")
end

myMod:log("✅ BetterRoads: Applied ultra-durable paved roads (~1000 years lifespan)")
