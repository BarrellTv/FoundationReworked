local myMod = ...

myMod:log("✅ BetterFishing.lua loaded")

myMod:overrideAsset({
    Id = "BUILDING_FUNCTION_FISHING_HUT",

    ResourceProduced = {
        {
            Resource = "FISH",
            Quantity = 40
        }
    },

    ProductionCycleDurationInSec = 2.5,  -- Reduced production time to 2.5 seconds
    OutputCapacity = 600,        -- Prevent storage overflow
    WorkerCapacity = 1        -- (Allow more workers to speed up production)
})



myMod:log("✅ Better Fishing override applied: faster, bigger hauls!")
