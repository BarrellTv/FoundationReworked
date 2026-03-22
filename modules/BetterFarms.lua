local myMod = ...
myMod:log("✅ BetterFarms.lua loaded")
-- BUILDING_FUNCTION_FARM
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_WHEAT_FARM",

	-- Increase amount gathered per harvest action
	ResourceValuePerGather = 10.0,	-- default: 1; on increase to 5, they gather 5 per harvest action. on 0.1, number of scythe strokes increases until at least 1 is gathered.
								-- this appears to be amount gathered per scythe stroke
								-- so what's a Gather and what's a HarvestStep? Gather == action where amount is gathered (coincides with scythe stroke); HarvestStep == Gather as part of a set comprising a Harvest; Harvest == action where amount gathered is brought to storage?
	-- Accelerate harvest action
	HarvestStepsCount = 1,	-- number of scythe strokes before returning to storage unless (amount gathered < 1, then repeat sets of HarvestStepsCount strokes until amount gathered >= 1 (i think?))
	QuantityToHarvestPerStep = 1,	-- total quantity to harvest per harvest action? if kept at default while HarvestStepsCount reduced to 1, harvesting doesn't continue past the first step and nothing is harvested. NB: quantity here appears to be completely cosmetic.
	-- i wonder if the visual "wheat" really is just cosmetic. would the wheat running out trigger the end of the harvest period even if that period hasn't timed out yet? so would increasing the yield per visual "wheat" effectively reduce the amount of space needed per farmer?

	SowingDurationPerc = {0,4},	-- appears to correspond to days of the month, but day 1 seems to vary (and offset by 1, looks like? so day 1 here is some week at day 2. wonder if it's 0-based.). each month has four weeks of seven days: 28 days total (0-27).
							-- after playing around with hops, this appears to be at least partly dynamic. 0 corresponds to day 1 at some week, then it runs through this cycle until restarting at 0. so a cycle ending at 6 will not stay at rest until 27 the way i thought it would. not sure if 0 always has to stay at day 1 of some week.
	GrowDuration = {4,5},
	GrowWaitDuration = {5,5},
	HarvestDuration = {5,26},
	RestDuration = {26,27},
})

-- BUILDING_FUNCTION_RESOURCE_DEPOT
-- Not increasing storage capacity to scale with harvest rate makes it a bottleneck BUT increasing it by this much completely removes the bottleneck thereby making it irrelevant in practice.
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_WHEATFARM_STORAGE_BASE",

	Capacity = 500,
})
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_WHEATFARM_STORAGE_IMPROVEMENT_LARGE",

	Capacity = 500,
})
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_WHEATFARM_STORAGE_IMPROVEMENT_SMALL",

	Capacity = 100,
})

---[[
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_HOP_FARM",

	-- fast harvest times so doesn't really benefit from extended harvest period. what would be really nice would be more frequent planting-harvest cycles.
	ResourceValuePerGather = 2.0,	-- default: 0.25? they harvest a rack 4 times before it's depleted, and that yields 1 unit of hops.

	HarvestStepsCount = 1,		-- by default, they harvest the entire field in one go? least they did 36 harvest steps (9 racks, 4 actions each) when tested. kinda cool.
							-- huh. changing HarvestStepsCount affects number of racks harvested, not number of actions.
	--QuantityToHarvestPerStep = 1,

	SowingDurationPerc = {0,1},
	GrowDuration = {1,2},
	GrowWaitDuration = {2,3},
	HarvestDuration = {3,6},
	RestDuration = {6,6},

	OutputCapacity = 600,
})
--]]
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_MONASTERY_VEGETABLE_GARDEN",

	ResourceValuePerGather = 1.7,	-- default: 1; on increase to 5, they gather 10 per harvest action

	--HarvestStepsCount = 1,
	--QuantityToHarvestPerStep = 1,

	-- planting and harvesting vegetables both slow, but also happen in small fields. without touching planting times, more time needed than with wheat, but less time needed for harvest.
	SowingDurationPerc = {0,4},
	GrowDuration = {4,5},
	GrowWaitDuration = {5,6},
	HarvestDuration = {7,27},
	RestDuration = {27,27},

	OutputCapacity = 5000,
})
myMod:overrideAsset({
	Id = "BUILDING_FUNCTION_VINEYARD",

	ResourceValuePerGather = 1.2,	-- default: 1; interestingly, on increase to 5, they gather 75 per harvest action

	--HarvestStepsCount = 1,
	--QuantityToHarvestPerStep = 1,

	-- grapes don't appear to have to be sown. bah, doch. and it's slow too. game crashes if sowing set to start and end on the same day.
	SowingDurationPerc = {0,1},	-- there's something i'm still not getting about grape planting. given seven days, they still don't tend to all of the vines and spend most of the time idle.
	--GrowDuration = {1,2},
	--GrowWaitDuration = {2,4},
	--HarvestDuration = {4,26},
	GrowDuration = {1,2},		-- vines that weren't planted at the sowing stage seem to appear here, but not reliably.
	GrowWaitDuration = {2,3},	-- grapes appear on the vine at this stage. if skipped, grapes pop in at harvest. hm, or maybe not. seems like they just pop in when you're not looking.
	HarvestDuration = {3,27},	-- while grapes do visibly disappear from the vine on harvest, this does not appear to affect functionality.
	RestDuration = {27,27},

	OutputCapacity = 5000,
})