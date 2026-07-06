local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local _StarterGui = game:GetService("StarterGui")
local Helper = require(ReplicatedStorage.Shared.Helper)

local HomeEvent = ReplicatedStorage.Remotes.HomeEvent
local GetMycoCapEvent = ReplicatedStorage.Remotes.GetMycoCapEvent

local ui = {} :: {
	Gui: typeof(_StarterGui.MainGui),
	Sidebar: typeof(_StarterGui.MainGui.Sidebar),
	MycoCap: typeof(_StarterGui.MainGui.MycoCap),
	HomeButton: typeof(_StarterGui.MainGui.HomeButton),
	Cash: typeof(_StarterGui.MainGui.Cash),
}

local MainGui = {}

function MainGui.Init()
	local playerGui = player:WaitForChild("PlayerGui")
	ui.Gui = playerGui:WaitForChild("MainGui")
	ui.Sidebar = ui.Gui:WaitForChild("Sidebar")
	ui.MycoCap = ui.Gui:WaitForChild("MycoCap")
	ui.HomeButton = ui.Gui:WaitForChild("HomeButton")
	ui.Cash = ui.Gui:WaitForChild("Cash")

	task.spawn(function()
		ui.Cash.Text = "$" .. Helper.FormatNumber(player:WaitForChild("leaderstats").Cash.Value)
	end)

	player:WaitForChild("leaderstats").Cash.Changed:Connect(function(amount: number)
		ui.Cash.Text = "$" .. Helper.FormatNumber(amount)
	end)

	ui.HomeButton.MouseButton1Click:Connect(function()
		HomeEvent:FireServer()
	end)

	GetMycoCapEvent:FireServer()
end

GetMycoCapEvent.OnClientEvent:Connect(function(amount: number)
	ui.MycoCap.MycoCapInventory.Text = Helper.FormatNumber(amount)
end)

return MainGui
