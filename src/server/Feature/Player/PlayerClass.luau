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

function PlayerClass.GetMushrooms(self: PlayerClass): { number }
	return self.Data.Mushrooms
end

function PlayerClass.UpdateMushrooms(self: PlayerClass, mushrooms: { number })
	self.Data.Mushrooms = mushrooms
end

function PlayerClass.GetMushroomCount(self: PlayerClass): number
	return self.Data.MushroomCount
end

function PlayerClass.UpdateMushroomCount(self: PlayerClass, increase: number)
	self.Data.MushroomCount += increase

	local mushroom = self.Leaderstats:FindFirstChild("Mushrooms") :: IntValue
	mushroom.Value = self.Data.MushroomCount
end

function PlayerClass.GetCash(self: PlayerClass) : number
	return self.Data.Cash
end

function PlayerClass.AddCash(self: PlayerClass, amount: number)
	self.Data.Cash += amount

	local cash = self.Leaderstats:FindFirstChild("Cash") :: IntValue
	cash.Value = self.Data.Cash
end

return PlayerClass
