local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Mushrooms = require(ReplicatedStorage.Shared.Modules.Mushrooms)
local MushroomClass = {}
MushroomClass.__index = MushroomClass

export type MushroomClass = typeof(setmetatable(
	{} :: {
		OwnerId: number,
		Tier: number,
		MycoCapAmount: number,
		Model: Model,
		MycoCapModel: Model,
	},
	MushroomClass
))

function MushroomClass.new(ownerId: number, tier: number, position: Vector3): MushroomClass
	local self = setmetatable({}, MushroomClass)

	local mushroom = Mushrooms[tier]

	self.OwnerId = ownerId
	self.Tier = tier
	self.Model = mushroom.Model:Clone()
	self.MycoCapModel = mushroom.MycoCapModel:Clone()
	self.MycoCapAmount = mushroom.MycoCapAmount

	self:SetPosition(position)

	self.Model.Parent = game.Workspace

	return self
end

function MushroomClass.SetPosition(self: MushroomClass, position: Vector3)
	local boxCF, size = self.Model:GetBoundingBox()

	local bottomOffset = boxCF.Position.Y - self.Model:GetPivot().Position.Y - size.Y / 2

	self.Model:PivotTo(CFrame.new(position + Vector3.new(0, -bottomOffset, 0)))
end

return MushroomClass
