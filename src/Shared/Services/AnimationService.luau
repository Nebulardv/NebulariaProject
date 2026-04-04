local AnimationService = {}

AnimationService.AnimationsCache = {}

function AnimationService.LoadAnimation(Character:Model, AnimationID: string, AnimationName: string)
	if not Character then
		print("No Character Found")
		return
	end
	local Humanoid: Humanoid = Character:FindFirstChild("Humanoid")
	if not Humanoid then
		print("No humanoid Found")
		return
	end
	local Animator: Animator = Humanoid:FindFirstChild("Animator")
	if not Animator then
		print("No Animator Found")
		return
	end
	
	local Animation = Instance.new("Animation")
	Animation.AnimationId = AnimationID
	Animation.Name = AnimationName
	
	if not AnimationService.AnimationsCache[Character] then
		AnimationService.AnimationsCache[Character] = {}
	end
	
	if not AnimationService.AnimationsCache[Character][AnimationName] then
		local LoadedTrack = Animator:LoadAnimation(Animation)
		AnimationService.AnimationsCache[Character][AnimationName] = LoadedTrack
	end
end

function AnimationService.PlayAnimation(Character: Model, AnimationName: string, WithFadeTime: "Yes" | nil, FadeTime: number?)
	if not AnimationService.AnimationsCache[Character] then
		print("Character does not have any Cached Anims")
		return
	end
	if AnimationService.AnimationsCache[Character][AnimationName] then
		local Animation = AnimationService.AnimationsCache[Character][AnimationName]
		if not Animation then
			print("Animation not found in Cached Animations")
			return
		end
		Animation:Play()
		return Animation
	end
	
	if WithFadeTime == "Yes" then
		local Animation = AnimationService.AnimationsCache[Character][AnimationName]
		if not Animation then
			print("Animation not found in Cached Animations")
			return
		end
		Animation:Play(FadeTime)
		return Animation
	end
end

function AnimationService.ClearCacheOnRemoval(Player: Player)
	Player.CharacterRemoving:Connect(function(Character:Model)
		AnimationService.AnimationsCache[Character] = nil
	end)
end

function AnimationService.OnMarkerReached(Character: Model, AnimationName: string, MarkerName: string, Callback: (any) -> (any))
	if not Character or not AnimationName or not MarkerName then
		return
	end
	if not AnimationService.AnimationsCache[Character] then
		print("Character does not have any Cached Anims")
		return
	end
	local AnimationTrack = AnimationService.AnimationsCache[Character][AnimationName]
	if not AnimationTrack then
		print("Animation not found in Cached Animations")
		return
	end
	local Connection
	Connection = AnimationTrack:GetMarkerReachedSignal(MarkerName):Connect(function()
		Callback()
		Connection:Disconnect()
	end)
end

function AnimationService.StopAnimation(Character: Model, AnimationName: string, WithFadeTime: "Yes" | nil, FadeTime: number?)
	if not Character or not AnimationName then
		return
	end
	if not AnimationService.AnimationsCache[Character] then
		print("Character does not have any Cached Anims")
		return
	end
	local AnimationTrack = AnimationService.AnimationsCache[Character][AnimationName]
	if not AnimationTrack then
		print("Animation not found in Cached Animations")
		return
	end
	AnimationTrack:Stop()
	
	if WithFadeTime == "Yes" then
		local Animation = AnimationService.AnimationsCache[Character][AnimationName]
		if not Animation then
			print("Animation not found in Cached Animations")
			return
		end
		Animation:Stop(FadeTime)
	end
end
return AnimationService
