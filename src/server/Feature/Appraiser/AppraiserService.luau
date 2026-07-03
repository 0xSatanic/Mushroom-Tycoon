local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = require(ServerScriptService.Feature.Player.PlayerService)
local PlotService = require(ServerScriptService.Feature.Plot.PlotService)
local AppraiserService = {}

local config = {
	BaseRate = 1,
	AppraiseInterval = 1,

	MultiplierMin = 0.5,
	MultiplierMax = 1.5,
	MultiplierInterval = 30,

	BaseUpgradePrice = 5,
	UpgradeCostMultiplierPerLevel = 1,
	RateMultiplierPerLevel = 1,
}

local currentMultiplier = 1

function AppraiserService.Init(player: Player)
	PlotService.UpdateIntValue(player, "MycoCapToAppraise", PlayerService.GetAppraiserStorage(player))
	PlotService.UpdateIntValue(player, "CashToCollect", PlayerService.GetCashToClaim(player))
	PlotService.UpdateIntValue(player, "AppraisalSpeed", AppraiserService.GetAppraiserRate(player))
	PlotService.UpdateIntValue(player, "AppraisalUpgradePrice", AppraiserService.GetUpgradePrice(player))
	PlotService.UpdateIntValue(player, "AppraisalUpgradeSpeedIncrease", AppraiserService.GetUpgradeRateIncrease(player))
end

function AppraiserService.CleanUp(player: Player)
	PlotService.UpdateIntValue(player, "MycoCapToAppraise", 0)
	PlotService.UpdateIntValue(player, "CashToCollect", 0)
	PlotService.UpdateIntValue(player, "AppraisalSpeed", 0)
	PlotService.UpdateIntValue(player, "AppraisalUpgradePrice", 0)
	PlotService.UpdateIntValue(player, "AppraisalUpgradeSpeedIncrease", 0)
end

function AppraiserService.GetAppraiserRate(player: Player): number
	local appraisalLevel = PlayerService.GetAppraiserRateLevel(player)

	return math.ceil(config.BaseRate * ((1 + config.RateMultiplierPerLevel) ^ (appraisalLevel - 1)))
end

function AppraiserService.GetUpgradePrice(player: Player): number
	local currentLevel = PlayerService.GetAppraiserRateLevel(player)

	return math.ceil(config.BaseUpgradePrice * ((1 + config.UpgradeCostMultiplierPerLevel) ^ (currentLevel - 1)))
end

function AppraiserService.GetUpgradeRateIncrease(player: Player): number
	local appraisalLevel = PlayerService.GetAppraiserRateLevel(player)

	local currentRate = AppraiserService.GetAppraiserRate(player)
	local nextRate = math.ceil(config.BaseRate * ((1 + config.RateMultiplierPerLevel) ^ appraisalLevel))

	return nextRate - currentRate
end

function AppraiserService.UpgradeAppraiserRateLevel(player: Player): boolean
	local cost = AppraiserService.GetUpgradePrice(player)

	if PlayerService.GetCash(player) < cost then
		return false
	end

	PlayerService.AddCash(player, -cost)
	PlayerService.UpgradeAppraiserRateLevel(player)

	PlotService.UpdateIntValue(player, "AppraisalSpeed", AppraiserService.GetAppraiserRate(player))
	PlotService.UpdateIntValue(player, "AppraisalUpgradePrice", AppraiserService.GetUpgradePrice(player))
	PlotService.UpdateIntValue(player, "AppraisalUpgradeSpeedIncrease", AppraiserService.GetUpgradeRateIncrease(player))

	return true
end

function AppraiserService.Deposit(player: Player)
	local mycoCapAmount = PlayerService.GetCapInventory(player)

	if mycoCapAmount <= 0 then
		return
	end

	print(player)

	local depositAmount = math.ceil(mycoCapAmount * currentMultiplier)

	PlayerService.AddCapInventory(player, -PlayerService.GetCapInventory(player))
	PlayerService.AddAppraiserStorage(player, depositAmount)

	PlotService.UpdateIntValue(player, "MycoCapToAppraise", PlayerService.GetAppraiserStorage(player))
end

function AppraiserService.CollectCash(player: Player): number?
	local claimedAmount = PlayerService.ClaimCash(player)

	if claimedAmount <= 0 then
		return nil
	end

	return claimedAmount
end

task.spawn(function()
	while true do
		game.Workspace.MiddlePart.Values.Timer.Value = config.MultiplierInterval

		while game.Workspace.MiddlePart.Values.Timer.Value > 0 do 
			task.wait(1)
			game.Workspace.MiddlePart.Values.Timer.Value -=1
		end

		local newMultiplier

		repeat
			newMultiplier = math.random(config.MultiplierMin * 10, config.MultiplierMax * 10) / 10
		until newMultiplier ~= currentMultiplier

		currentMultiplier = newMultiplier
		game.Workspace.MiddlePart.Values.CurrentMultiplier.Value = currentMultiplier
	end
end)

task.spawn(function()
	while true do
		task.wait(config.AppraiseInterval)

		for _, player in Players:GetPlayers() do
			local storage = PlayerService.GetAppraiserStorage(player)

			if storage <= 0 then
				continue
			end

			local appraisalRate = AppraiserService.GetAppraiserRate(player)

			local processedAmount = math.min(appraisalRate, storage)

			PlayerService.AddAppraiserStorage(player, -processedAmount)
			PlayerService.AddCashToClaim(player, processedAmount)

			PlotService.UpdateIntValue(player, "MycoCapToAppraise", PlayerService.GetAppraiserStorage(player))
			PlotService.UpdateIntValue(player, "CashToCollect", PlayerService.GetCashToClaim(player))
		end
	end
end)

return AppraiserService
