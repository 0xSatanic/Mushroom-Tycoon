--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MushroomsFolder = ReplicatedStorage.Assets.Models.Mushrooms
local MycoCapsFolder = ReplicatedStorage.Assets.Models.MycoCaps

type Mushrooms = {
	Tier: number,
	DisplayName: string,
	MycoCapAmount: number,
	Model: Model,
	MycoCapModel: Model,
}

local Mushrooms: { [number]: Mushrooms } = {
	[1] = {
		Tier = 1,
		DisplayName = "ay ay",
		MycoCapAmount = 1,
		Model = MushroomsFolder[1],
		MycoCapModel = MycoCapsFolder[1],
	},
}

return Mushrooms
