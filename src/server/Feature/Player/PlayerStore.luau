--!strict

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")

local profilestore = require(ServerScriptService.ServerPackages.profilestore)

export type playerDataTemplate = {
	Cash: number,

	Mushrooms: { number }, -- tier
	MushroomCount: number,

	CapInventory: number,
	AppraiserStorage: number,
	CashToClaim: number,

	AppraiserRateLevel: number,

	LastOnlineTimestamp: number,
}

local template: playerDataTemplate = {
	Cash = 0,
	Mushrooms = {},
	MushroomCount = 0,
	CapInventory = 0,
	AppraiserStorage = 0,
	CashToClaim = 0,
	AppraiserRateLevel = 1,
	LastOnlineTimestamp = 0,
}

local Store = profilestore.New(RunService:IsStudio() and "Test" or "PlayerData", template)
local PlayerStore = {}
local Profiles = {}

function PlayerStore.Init(player: Player)
	local profile = Store:StartSessionAsync("Player_" .. player.UserId, {
		Cancel = function()
			return player.Parent ~= Players
		end,
	})

	if profile == nil then
		player:Kick("Data error occured. Please rejoin")
		return
	end

	profile.OnSessionEnd:Connect(function()
		player:Kick("Data error occured. Please rejoin")
		Profiles[player.UserId] = nil
	end)

	if player.Parent ~= Players then
		profile:EndSession()
	end

	profile:AddUserId(player.UserId)
	profile:Reconcile()

	Profiles[player.UserId] = profile
end

function PlayerStore.CleanUp(player: Player)
	local profile = Profiles[player.UserId]

	if not profile then
		return
	end

	Profiles[player.UserId] = nil
	profile:EndSession()
end

function PlayerStore.GetData(userId: number)
	return Profiles[userId].Data
end

return PlayerStore
