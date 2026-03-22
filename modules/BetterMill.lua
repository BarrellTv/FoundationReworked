local myMod = ...
myMod:log("✅ BetterMill.lua loaded")

myMod:overrideAsset({
    Id = "BUILDING_FUNCTION_WINDMILL",

    InputInventoryCapacity = { { Resource = "WHEAT", Quantity = 200 } },
    ResourceListNeeded    = { { Resource = "WHEAT", Quantity = 10 } },
    ResourceProduced      = { { Resource = "FLOUR", Quantity = 8 } },
    OutputCapacity        = 100,
    ProductionCycleDurationInSec = 18,
    WorkCycleNeededToProduceOnce = 1,
})
