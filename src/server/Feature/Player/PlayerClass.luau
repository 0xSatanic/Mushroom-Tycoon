--!strict

local PlayerStore = require(script.Parent.PlayerStore)

local PlayerClass = {}
PlayerClass.__index = PlayerClass

export type PlayerClass = typeof(setmetatable(
	{} :: {
		Player: Player,
		Data: PlayerStore.playerDataTemplate,
		Leaderstats: Folder,
	},
	PlayerClass
))

function PlayerClass.new(player: Player, data: PlayerStore.playerDataTemplate)
	local self = setmetatable({}, PlayerClass)

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

	local Cash = Instance.new("IntValue")
	Cash.Name = "Cash"
	Cash.Parent = leaderstats
	Cash.Value = data.Cash

	local Mushrooms = Instance.new("IntValue")
	Mushrooms.Name = "Mushrooms"
	Mushrooms.Parent = leaderstats
	Mushrooms.Value = data.MushroomCount

	self.Player = player
	self.Data = data
	self.Leaderstats = leaderstats

	return self
end

function PlayerClass.GetMushrooms(self: PlayerClass) 
    return self.Data.Mushrooms
end

return PlayerClass
