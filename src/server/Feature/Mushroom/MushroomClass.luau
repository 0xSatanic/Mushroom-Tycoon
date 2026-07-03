local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mushrooms = require(ReplicatedStorage.Shared.Modules.Mushrooms)

local SpawnMycoCapEvent = ReplicatedStorage.Remotes.SpawnMycoCapEvent

local MushroomClass = {}
MushroomClass.__index = MushroomClass

export type MushroomClass = typeof(setmetatable(
	{} :: {
		OwnerId: number,
		Tier: number,
		MycoCapAmount: number,
		Model: Model,
		MycoCapModel: Model,
		PlotNumber: number
	},
	MushroomClass
))

function MushroomClass.new(ownerId: number, tier: number, plotNumber: number): MushroomClass
	local self = setmetatable({}, MushroomClass)

	local mushroom = Mushrooms[tier]

	self.OwnerId = ownerId
	self.Tier = tier
	self.Model = mushroom.Model:Clone()
	self.MycoCapModel = mushroom.MycoCapModel
	self.MycoCapAmount = mushroom.MycoCapAmount
	self.PlotNumber = plotNumber

	return self
end

function MushroomClass.Destroy(self: MushroomClass)
	self.Model:Destroy()
end

function MushroomClass.SetPosition(self: MushroomClass, position: Vector3)
	local boxCF, size = self.Model:GetBoundingBox()

	local bottomOffset = boxCF.Position.Y - self.Model:GetPivot().Position.Y - size.Y / 2

	self.Model:PivotTo(CFrame.new(position + Vector3.new(0, -bottomOffset, 0)))

	self.Model.Parent = game.Workspace.Plots[self.PlotNumber].Mushrooms
end

function MushroomClass.GetPosition(self: MushroomClass): Vector3
	return self.Model:GetPivot().Position
end

function MushroomClass.SpawnMycoCap(self: MushroomClass) : string
	local mushroomPosition = self:GetPosition()
	
	local button = game.Workspace.Plots[self.PlotNumber].Buttons.Merge.Button

	local direction = button.CFrame.LookVector

	local spawnCFrame = CFrame.new(mushroomPosition + direction * -8)

	local capId = HttpService:GenerateGUID(false)

	SpawnMycoCapEvent:FireClient(Players:GetPlayerByUserId(self.OwnerId), capId, self.Tier, spawnCFrame, self.PlotNumber)


	return capId
end

return MushroomClass
