local myMod = ...
myMod:log("✅ BetterLumberCamp.lua loaded")

myMod:overrideAsset({
    Id = "BUILDING_FUNCTION_WOODCUTTER",
    ResourceProduced = {
        {
            Resource = "WOOD",
            Quantity = 5
        }
    },
    WorkerCapacity = 6   --(default 3)
})

myMod:overrideAsset({
    Id = "BUILDING_FUNCTION_WOODCUTTER_STORAGE_BASE",
    Capacity = 300   --(default 50)
})
