local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Mushrooms = require(ReplicatedStorage.Shared.Modules.Mushrooms)
local PlayerService = require(ServerScriptService.Feature.Player.PlayerService)
local MushroomClass = require(script.Parent.MushroomClass)
local PlotService = require(ServerScriptService.Feature.Plot.PlotService)

local MushroomService = {}

local MushroomObjs: { [number]: { [number]: { MushroomClass.MushroomClass } } } = {} -- {[userId] : {[tier] : obj}}

local config = {
	BasePrice = 5,
	PriceMultiplier = 0.15,
	MaxMushroomInThePlot = 60
}

function MushroomService.Init(player: Player)
	MushroomObjs[player.UserId] = {}

	local mushrooms = PlayerService.GetMushrooms(player)

	table.sort(mushrooms, function(a, b)
		return a > b
	end)

	for _, tier in mushrooms do
		MushroomService.Create(player, tier)
	end

	MushroomService.RecalculatePosition(player)


	local mushroomCount = PlayerService.GetMushroomCount(player)
	local plotNumber = PlotService.GetPlotNumber(player)
	game.Workspace.Plots[plotNumber].Buttons.MushroomPrice.Value = math.ceil((config.BasePrice * (1 + config.PriceMultiplier) ^ mushroomCount)) 

end

function MushroomService.CleanUp(player: Player)
	local playerMushrooms = MushroomObjs[player.UserId]

	if not playerMushrooms then
		return
	end

	for _, tier in playerMushrooms do
		for _, mushroom in tier do
			mushroom:Destroy()
		end
	end

	MushroomObjs[player.UserId] = nil
end

function MushroomService.Create(player: Player, tier: number)
	local mushroomObj = MushroomClass.new(player.UserId, tier)

	if not MushroomObjs[player.UserId][tier] then
		MushroomObjs[player.UserId][tier] = {}
	end

	table.insert(MushroomObjs[player.UserId][tier], mushroomObj)
end

function MushroomService.Buy(player: Player, amount: number) : (boolean, string?)
	if amount ~= 1 and amount ~= 5 and amount ~= 25 and amount ~= 100 then
		return false, "Invalid Buy Amount"
	end

	local mushroomCount = PlayerService.GetMushroomCount(player)
	
	local price = math.ceil((config.BasePrice * (1 + config.PriceMultiplier) ^ mushroomCount) * amount)
	
	if PlayerService.GetCash(player) < price then 
		return false, "Not Enough Cash"
	end

	PlayerService.UpdateCash(player, -price)

	for _ = 1, amount do 
		MushroomService.Create(player, 1)
	end
	
	local playerMushrooms = MushroomObjs[player.UserId]
	local count = 0

	for _, list in playerMushrooms do
		count += #list
	end

	if count > config.MaxMushroomInThePlot then 
		MushroomService.Merge(player)
	else 
		MushroomService.SaveMushroomsData(player)
		MushroomService.RecalculatePosition(player)
	end

	PlayerService.AddMushroomCount(player, amount)
	
	local plotNumber = PlotService.GetPlotNumber(player)
	game.Workspace.Plots[plotNumber].Buttons.MushroomPrice.Value = math.ceil((config.BasePrice * (1 + config.PriceMultiplier) ^ (mushroomCount + amount))) 

	return true
end

function MushroomService.RecalculatePosition(player: Player)
	local playerMushrooms = MushroomObjs[player.UserId]

	if not playerMushrooms then
		return
	end

	local currentTier = 0
	for t in playerMushrooms do
		currentTier = math.max(t, currentTier)
	end

	local plotNumber = PlotService.GetPlotNumber(player)
	local i = 1

	while currentTier >= 1 do
		local list = playerMushrooms[currentTier]

		currentTier -= 1

		if not list then
			continue
		end

		for _, mushroom in list do
			mushroom:SetPosition(game.Workspace.Plots[plotNumber].MushroomSpawn[i].Position)
			i += 1
		end
	end
end

function MushroomService.Merge(player: Player)
	local playerMushrooms = MushroomObjs[player.UserId]

	if not playerMushrooms then
		return
	end

	local highestTier = 0
	for t in playerMushrooms do
		highestTier = math.max(t, highestTier)
	end

	local tier = 1
	while tier <= highestTier do
		local list = playerMushrooms[tier]

		while list and #list >= 3 and Mushrooms[tier + 1] do
			local mushroomA = table.remove(list) :: MushroomClass.MushroomClass
			local mushroomB = table.remove(list) :: MushroomClass.MushroomClass
			local mushroomC = table.remove(list) :: MushroomClass.MushroomClass

			mushroomA:Destroy()
			mushroomB:Destroy()
			mushroomC:Destroy()

			local newMushroom = MushroomClass.new(player.UserId, tier + 1)

			if not playerMushrooms[tier + 1] then
				playerMushrooms[tier + 1] = {}
			end

			table.insert(playerMushrooms[tier + 1], newMushroom)

			highestTier = math.max(highestTier, tier + 1)
		end

		tier += 1
	end

	MushroomService.SaveMushroomsData(player)
	MushroomService.RecalculatePosition(player)
end

function MushroomService.SaveMushroomsData(player: Player) 
	local playerMushrooms = MushroomObjs[player.UserId]

	local updatedMushrooms = {}
	for mushroomTier, list in playerMushrooms do
		for _ in list do
			table.insert(updatedMushrooms, mushroomTier)
		end
	end

	PlayerService.UpdateMushrooms(player, updatedMushrooms)
end

return MushroomService
