--!strict

local PlayerClass = require(script.Parent.PlayerClass)
local PlayerStore = require(script.Parent.PlayerStore)
local PlayerService = {}

local PlayersObj: { [number]: PlayerClass.PlayerClass } = {}

function PlayerService.Init(player: Player)
	local playerData = PlayerStore.GetData(player.UserId)
	local playerObj = PlayerClass.new(player, playerData)

	PlayersObj[player.UserId] = playerObj
end

function PlayerService.CleanUp(player: Player)
	PlayersObj[player.UserId] = nil
end

function PlayerService.WaitForPlayerObj(player: Player): PlayerClass.PlayerClass?
	local start = os.clock()
	local timeout = 10

	while not PlayersObj[player.UserId] do
		if os.clock() - start > timeout then
			return nil
		end

		task.wait(0.1)
	end

	return PlayersObj[player.UserId]
end

function PlayerService.GetMushrooms(player: Player): { number }
	local playerObj = PlayerService.WaitForPlayerObj(player)

	if not playerObj then
		return {}
	end

	return playerObj:GetMushrooms()
end

function PlayerService.UpdateMushrooms(player: Player, mushrooms: { number })
	local playerObj = PlayerService.WaitForPlayerObj(player)

	if not playerObj then
		return
	end

	playerObj:UpdateMushrooms(mushrooms)
end

function PlayerService.GetMushroomCount(player: Player): number
	local playerObj = PlayerService.WaitForPlayerObj(player)

	if not playerObj then
		return 0
	end

	return playerObj:GetMushroomCount()
end

function PlayerService.AddMushroomCount(player: Player, increase: number)
	local playerObj = PlayerService.WaitForPlayerObj(player)

	if not playerObj then
		return
	end

	playerObj:UpdateMushroomCount(increase)
end

function PlayerService.GetCash(player: Player): number
	local playerObj = PlayerService.WaitForPlayerObj(player)

	if not playerObj then
		return 0
	end

	return playerObj:GetCash()
end

function PlayerService.UpdateCash(player: Player, amount: number)
	local playerObj = PlayerService.WaitForPlayerObj(player)

	if not playerObj then
		return
	end

	playerObj:AddCash(amount)
end

return PlayerService
