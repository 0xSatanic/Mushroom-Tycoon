local StarterPlayer = game:GetService("StarterPlayer")
local MycoCapsService = require(StarterPlayer.StarterPlayerScripts.Service.MycoCapsService)
local SoundService = require(StarterPlayer.StarterPlayerScripts.Service.SoundService)
local UI = require(script.Parent.UI)

UI.Init()
MycoCapsService.Init()
SoundService.Init()