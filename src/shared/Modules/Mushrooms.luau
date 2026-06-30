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
	[2] = {
		Tier = 2,
		DisplayName = "ay ay",
		MycoCapAmount = 4,
		Model = MushroomsFolder[2],
		MycoCapModel = MycoCapsFolder[2],
	},
	[3] = {
		Tier = 3,
		DisplayName = "ay ay",
		MycoCapAmount = 4,
		Model = MushroomsFolder[3],
		MycoCapModel = MycoCapsFolder[3],
	},
}

return Mushrooms
