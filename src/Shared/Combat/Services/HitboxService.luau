--[[ BY: @strb575(Nebular/NebularAxis)
	NebHitboxService is a clean, simple, beginner friendly module that makes hitbox creation
	as easy as calling a few functions. This module is not designed for production level work, rather to
	simplify hitbox creation for beginners stepping into development.
	
]]
local ReplicatredStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatredStorage.SharedModules
local CombatModules = Shared.Combat
local Services = CombatModules.Services

type HitboxDataType = {
	HitboxCFrame: CFrame,
	HitboxSize: Vector3,
	HitboxOverlapParams: OverlapParams,
}


local CreateVisualizePart = function(HitboxCFrame, HitboxSize)
	local HitboxVisualizer = Instance.new("Part")
	HitboxVisualizer.Anchored = true
	HitboxVisualizer.CanCollide = false
	HitboxVisualizer.CanQuery = false
	HitboxVisualizer.CanTouch = false
	HitboxVisualizer.Transparency = 0.5
	HitboxVisualizer.Color = Color3.new(1, 0, 0)
	HitboxVisualizer.Material = Enum.Material.SmoothPlastic
	HitboxVisualizer.CFrame = HitboxCFrame
	HitboxVisualizer.Size = HitboxSize
	HitboxVisualizer.Parent = workspace
	return HitboxVisualizer
	end
	
local DestroyVisualizePart = function(Visualizer)
	assert(Visualizer:IsA("BasePart"), "Visualizer Hitbox is not a basepart")
	if Visualizer:IsA("BasePart") then
		Visualizer:Destroy()
	end
end


local HitboxService = {}

function HitboxService.CreateHitbox(HitboxData: HitboxDataType, Owner: Player)
	local Character = Owner.Character or Owner.CharacterAdded:Wait()
	local HitboxCFrame = HitboxData.HitboxCFrame
	local HitboxSize = HitboxData.HitboxSize
	local HitboxOverlapParams = HitboxData.HitboxOverlapParams
	HitboxOverlapParams.FilterType = Enum.RaycastFilterType.Exclude
	HitboxOverlapParams.FilterDescendantsInstances = {Character}
	
	local Hitbox = workspace:GetPartBoundsInBox(HitboxCFrame, HitboxSize, HitboxOverlapParams)
	
	local HitboxObject = Hitbox
	
	return HitboxObject
end

function HitboxService.GetHitboxData(HitboxObj)
	local InHitbox = {}
	local AlreadyDetected = {}

	for _, HitboxItem in HitboxObj do
		if AlreadyDetected[HitboxItem] then
			return
		end
		table.insert(InHitbox, HitboxItem)
	end
	for _, DetectedItem in InHitbox do
		AlreadyDetected[DetectedItem] = true
	end
	
	return InHitbox
end

function HitboxService.VisualizeHitbox(HitboxCFrame, HitboxSize)
	local HitboxVisualizer = CreateVisualizePart(HitboxCFrame, HitboxSize)
	return HitboxVisualizer
end

function HitboxService.DestroyVisualizer(HitboxVisualizer, DurationToWait)
	task.wait(DurationToWait)
	DestroyVisualizePart(HitboxVisualizer)
end

function HitboxService.CleanupHitbox(HitboxObj)
	table.clear(HitboxObj)
end


return HitboxService
