type SoundProperties = {
	SoundId: string?,
	Volume: number?,
	PlaybackSpeed: number?,
	Playing: boolean?,
	Looped: boolean?,
	TimePosition: number?,
}


local EffectsService = {}

function EffectsService.PlayVisualEffects(Position: CFrame | Vector3, EffectAttachment: Attachment, Parent, EmitCount: number, DestroyTime: number)
	if typeof(Position) == "Vector3" then
		EffectAttachment.Parent = Parent
		EffectAttachment.WorldPosition = Position
	elseif typeof (Position) == "CFrame" then
		EffectAttachment.Parent = Parent
		EffectAttachment.WorldCFrame = Position
	end
	
	for _, ParticleEmitter in EffectAttachment:GetDescendants() do
		if not ParticleEmitter:IsA("ParticleEmitter") then
			continue
		end
		ParticleEmitter:Emit(EmitCount)
	end
	
	task.delay(DestroyTime, function()
		EffectAttachment:Destroy()
	end)
	
	return EffectAttachment
end

function EffectsService.DestroyVisualEffectWithWait(Effect:Attachment, TimeToWait: number)
	task.wait(TimeToWait)
	Effect:Destroy()
end

function EffectsService.PlaySoundEffects(Sound: Sound, SoundParent: Model | BasePart | Part | any)
	Sound.Parent = SoundParent
	Sound:Play()
	Sound.Ended:Wait()
	Sound:Destroy()
end

function EffectsService.DestroySoundEffect(Sound: Sound, DestroyTime: number?)
	if DestroyTime then
		task.delay(DestroyTime, function()
			Sound:Destroy()
		end)
	else
		Sound:Destroy()
	end
end

function EffectsService.MutateSoundProperty(
	Sound: Sound,
	Property:  SoundProperties,
	Value: number | boolean | string
)
	Sound[Property[1]] = Value  -- Sound[Property[1]] returns the first item passed in in the property table
end

return EffectsService
