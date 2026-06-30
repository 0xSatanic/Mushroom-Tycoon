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

	plot.OwnerId.Value = player.UserId

	local char = player.Character or player.CharacterAdded:Wait()

	char:PivotTo(plot.Spawn.CFrame)
end

function PlotService.CleanUp(player: Player)
	for i = 1, 8 do
		if Plots[i] == player.UserId then
			local plot: typeof(game.Workspace.Plots["1"]) = game.Workspace.Plots[i]
			plot.OwnerId.Value = 0
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

return PlotService
