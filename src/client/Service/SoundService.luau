local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RBLXSoundService = game:GetService("SoundService")

local SoundsFolder = ReplicatedStorage.Assets.Sounds

local PlaySoundEvent = ReplicatedStorage.Remotes.PlaySoundEvent

local SoundService = {}

local soundCache: { [string]: Sound } = {}

function SoundService.Init() 
    for _, sound in SoundsFolder:GetChildren() do
        SoundService.GetSound(sound.Name)
    end
end

function SoundService.GetSound(soundName: string): Sound?
	if soundCache[soundName] then
		return soundCache[soundName]
	end

	local sound = SoundsFolder:FindFirstChild(soundName)

	if not sound then
		warn(`[SoundService] Sound "{soundName}" tidak ditemukan di ReplicatedStorage.Sounds`)
		return nil
	end

	soundCache[soundName] = sound

	return sound
end

function SoundService.Play(soundName: string)
	local original = SoundService.GetSound(soundName)
	if not original then
		return
	end

    local clone = original:Clone()
    clone.Parent = RBLXSoundService

    clone:Play()

    clone.Ended:Once(function()
        clone:Destroy()
    end)

    task.delay(clone.TimeLength + 1, function()
        clone:Destroy()
    end)
end

PlaySoundEvent.OnClientEvent:Connect(function(soundName: string)
    SoundService.Play(soundName)
end)

return SoundService
