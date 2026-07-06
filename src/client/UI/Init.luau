local UI = {}

function UI.Init()
	for _, moduleScript in pairs(script:GetChildren()) do
		if moduleScript:IsA("ModuleScript") then
			local module = require(moduleScript)
			if module.Init then
				task.spawn(function()
					module.Init()
				end)
			end
		end
	end
end

return UI
