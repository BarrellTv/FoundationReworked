local myMod = ...
myMod:log("✅ BetterSawMill.lua loaded")

myMod:overrideAsset({
    Id = "BUILDING_FUNCTION_SAWMILL",

    ResourceProduced = {
        {
            Resource = "PLANK",
            Quantity = 5
        }
    },

    ProductionCycleDurationInSec = 4.5,   -- Faster cycle
    OutputCapacity = 400,        -- Prevent storage overflow
    WorkerCapacity = 3,        -- Allow more workers to speed up production
    InputInventoryCapacity = {
        { Resource = "WOOD", Quantity = 100 }
    } -- Allow more logs to be stored
})
