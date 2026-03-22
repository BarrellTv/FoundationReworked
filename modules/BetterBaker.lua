local myMod = ...
myMod:log("✅ BetterBaker.lua loaded")

myMod:overrideAsset({
    Id = "BUILDING_FUNCTION_BAKERY",

    InputInventoryCapacity = { { Resource = "FLOUR", Quantity = 200 } },
    ResourceListNeeded    = { { Resource = "FLOUR", Quantity = 10 } },
    ResourceProduced      = { { Resource = "BREAD",  Quantity = 8 } },
    OutputCapacity        = 100,
    ProductionCycleDurationInSec = 15,
    WorkCycleNeededToProduceOnce = 1,
})
