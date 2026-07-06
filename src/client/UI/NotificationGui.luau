local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local _StarterGui = game:GetService("StarterGui")

local ShowNotificationEvent = ReplicatedStorage.Remotes.ShowNotificationEvent

local ui = {} :: {
	Gui: typeof(_StarterGui.NotificationGui),
	NotificationFrame: typeof(_StarterGui.NotificationGui.NotificationFrame),
	Notification: typeof(_StarterGui.NotificationGui.NotificationFrame.Notification),
}

local Config = {
	FadeInTime = 0.15,
	FadeOutTime = 0.35,
	HoldTimer = 2,
}

local currentDelayThread: thread? = nil

local NotificationGui = {}

function NotificationGui.Init()
	local playerGui = player:WaitForChild("PlayerGui")
	ui.Gui = playerGui:WaitForChild("NotificationGui")
	ui.NotificationFrame = ui.Gui:WaitForChild("NotificationFrame")
	ui.Notification = ui.NotificationFrame:WaitForChild("Notification")

	ui.Gui.Enabled = false
	ui.Notification.TextTransparency = 1
	ui.NotificationFrame.BackgroundTransparency = 1
end

function NotificationGui.CancelPrevious()
	if currentDelayThread then
		task.cancel(currentDelayThread)
		currentDelayThread = nil
	end
end

ShowNotificationEvent.OnClientEvent:Connect(function(type: "perfect" | "success" | "failed" | "normal", text: string)
	NotificationGui.CancelPrevious()

	local textColor

	if type == "perfect" then
		textColor = Color3.fromRGB(255, 204, 2)
	elseif type == "success" then
		textColor = Color3.fromRGB(17, 255, 0)
	elseif type == "failed" then
		textColor = Color3.fromRGB(255, 49, 49)
	else
		textColor = Color3.fromRGB(255, 255, 255)
	end

	ui.Notification.Text = text
	ui.Notification.TextTransparency = 1
	ui.Notification.TextColor3 = textColor
	ui.NotificationFrame.BackgroundTransparency = 1
	ui.Gui.Enabled = true

	local fadeInTextTween = TweenService:Create(
		ui.Notification,
		TweenInfo.new(Config.FadeInTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ TextTransparency = 0 }
	)

	local fadeInFrameTween = TweenService:Create(
		ui.NotificationFrame,
		TweenInfo.new(Config.FadeInTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{ BackgroundTransparency = 0.6 }
	)

	fadeInTextTween:Play()
	fadeInFrameTween:Play()

	currentDelayThread = task.delay(Config.HoldTimer, function()
		local fadeOutTextTween = TweenService:Create(
			ui.Notification,
			TweenInfo.new(Config.FadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ TextTransparency = 1 }
		)

		local fadeOutFrameTween = TweenService:Create(
			ui.NotificationFrame,
			TweenInfo.new(Config.FadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{ BackgroundTransparency = 1 }
		)

		fadeOutTextTween:Play()
		fadeOutFrameTween:Play()

		fadeOutFrameTween.Completed:Once(function()
			ui.Gui.Enabled = false
		end)
	end)
end)

return NotificationGui
