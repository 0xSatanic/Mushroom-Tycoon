local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mushrooms = require(ReplicatedStorage.Shared.Modules.Mushrooms)

local SpawnMycoCapEvent = ReplicatedStorage.Remotes.SpawnMycoCapEvent
local CollectMycoCapEvent = ReplicatedStorage.Remotes.CollectMycoCapEvent

local player = Players.LocalPlayer
local MycoCapsService = {}

function MycoCapsService.Init()
	SpawnMycoCapEvent.OnClientEvent:Connect(function(capId: string, tier: number, CFrame: CFrame, plotNumber: number)
		local mushroomData = Mushrooms[tier]

		if not mushroomData then
			return
		end

		local mycoCapModel = mushroomData.MycoCapModel:Clone()
		mycoCapModel.Parent = game.Workspace.Plots[plotNumber].MycoCaps
		mycoCapModel:PivotTo(CFrame)
		mycoCapModel.Name = capId

		local mainPart = mycoCapModel.Main :: MeshPart

		local collected = false

		mainPart.Touched:Connect(function(hit: BasePart)
			if collected then
				return
			end

			if not hit.Parent then
				return
			end

			local character = player.Character
			if not character or not hit:IsDescendantOf(character) then
				return
			end
			collected = true

			mycoCapModel:Destroy()

            CollectMycoCapEvent:FireServer(tier, capId)
		end)
	end)
end

return MycoCapsService
