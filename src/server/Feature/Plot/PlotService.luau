local PlotService = {}

local Plots: { [number]: number } = {}

function PlotService.Init(player: Player)
	local plotNumber
	for i = 1, 8 do
		if Plots[i] then
			continue
		else
			plotNumber = i
			Plots[i] = player.UserId
			PlotService.UpdateIntValue(player, "OwnerId", player.UserId)
			break
		end
	end

	if not plotNumber then
		warn("No plot available for " .. player.Name)
		return
	end

	local plot: typeof(game.Workspace.Plots["1"]) = game.Workspace.Plots[plotNumber]

	player.CharacterAdded:Connect(function(char: Model)
		char:PivotTo(plot.Spawn.CFrame)
	end)

	local char = player.Character or player.CharacterAdded:Wait()

	char:PivotTo(plot.Spawn.CFrame)
end

function PlotService.CleanUp(player: Player)
	for i = 1, 8 do
		if Plots[i] == player.UserId then
			PlotService.UpdateIntValue(player, "OwnerId", 0)
			Plots[i] = nil
			break
		end
	end
end

function PlotService.GetPlotNumber(player: Player)
	local plotNumber
	for i = 1, 8 do
		if Plots[i] == player.UserId then
			plotNumber = i
			break
		end
	end

	return plotNumber
end

function PlotService.UpdateIntValue(player: Player, valueName: string, amount: number)
	local plotNumber = PlotService.GetPlotNumber(player)

	local plot: typeof(game.Workspace.Plots["1"]) = game.Workspace.Plots[plotNumber]
	local IntValue = plot.Values:FindFirstChild(valueName) :: IntValue?

	if not IntValue then
		warn("PlotService.UpdateValue: value '" .. valueName .. "' not found in plot " .. plotNumber)
		return
	end

	IntValue.Value = amount
end

return PlotService
