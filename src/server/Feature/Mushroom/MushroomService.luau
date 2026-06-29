local ServerScriptService = game:GetService("ServerScriptService")
local PlayerService = require(ServerScriptService.Feature.Player.PlayerService)
local MushroomClass = require(script.Parent.MushroomClass)
local PlotService = require(ServerScriptService.Feature.Plot.PlotService)
local MushroomService = {}

local MushroomObjs: { [number]: { MushroomClass.MushroomClass } } = {}

function MushroomService.Init(player: Player)
	-- local mushrooms = PlayerService.GetMushrooms(player)

	-- table.sort(mushrooms, function(a, b)
	-- 	return a > b
	-- end)

	-- for i, tier in mushrooms do
	-- 	MushroomService.Create(player, i, tier)
	-- end

	MushroomService.Create(player, 1, 1)
end

function MushroomService.Create(player: Player, slotIndex: number, tier: number): MushroomClass.MushroomClass
	local plotNumber = PlotService.GetPlotNumber(player)

	local position = game.Workspace.Plots[plotNumber].MushroomSpawn[slotIndex].Position

	local mushroomObj = MushroomClass.new(player.UserId, tier, position)

	return mushroomObj
end

-- function MushroomService.Place(player: Player, mushroomObj: MushroomClass.MushroomClass)
-- 	local plotNumber = PlotService.GetPlotNumber(player)
-- end

return MushroomService
