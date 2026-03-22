--[[ ==========================================Default values 
    AssetZonePatrol = "RESIDENTIAL"
	BaseValueOnPatrol = 30.0
	PatrolEffectDistance = 10.0
	PatrolDistanceBoostPerGroupSize = 1.0
	PatrollerRangeVisualWidth = 1.0
	PatrolDepletionRate = 0.1
	EmptyPatrolWeightValue = 250.0
	RequiredPatrolAdditionalWeightValue = 20
	DelayBetweenPatrollerInGroup = 0.0
    PatrollerGroupingMaximumWaitTimeProportion = 0.5
	ActiveFortificationDisableTime = 60.0
--]]
local myMod = ...
myMod:log("✅ BetterPatrols.lua loaded")

myMod:overrideAsset({
    Id = "DEFAULT_SAFETY_SETTINGS",
	BaseValueOnPatrol = 25.0,
	PatrolEffectDistance = 12.5,
	PatrolDistanceBoostPerGroupSize = 1.5,
	PatrollerRangeVisualWidth = 1.2,
	PatrolDepletionRate = 0.05, --Safety value decreased every second, can be decimal (0.1 will remove 1 safety value every 10 seconds)
	EmptyPatrolWeightValue = 400.0,	--Weight Multiplier for missing patrol value. Weight = (MissingPatrolPercentage * m_emptyPatrolWeightValue) - distanceFromWorkplace. Higher the weight → higher the priority.
	RequiredPatrolAdditionalWeightValue = 50, --Additional Weight for houses about to downgrade
	DelayBetweenPatrollerInGroup = 7.5, --Delay between each patroller leaving for patrol after grouping
    PatrollerGroupingMaximumWaitTimeProportion = 0.001, --Maximum time proportion of work time left before forcing a patrol group to start patrolling
	ActiveFortificationDisableTime = 90.0 --Time (in seconds) to wait after guard left to disable active fortification
})