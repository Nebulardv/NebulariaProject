local Debris = game:GetService("Debris")

local ReplicatredStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatredStorage.SharedModules
local Services = Shared.Services


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
	

local HitboxService = {}

function HitboxService.VisualizeHitbox(HitboxCFrame, HitboxSize, DestroyTime: number)
	local HitboxVisualizer = CreateVisualizePart(HitboxCFrame, HitboxSize)
	task.defer(function()
		Debris:AddItem(HitboxVisualizer, DestroyTime)
	end)
	
	return HitboxVisualizer
end


function HitboxService.CreateHitbox(
	HitboxCFrameParam: CFrame,
	HitboxSizeParam: Vector3,
	HitboxParams: OverlapParams
)
	
	local Hitbox = workspace:GetPartBoundsInBox(HitboxCFrameParam, HitboxSizeParam, HitboxParams)
	
	local HitboxObject = Hitbox
	
	
	return HitboxObject
end

function HitboxService.GetHitboxData(HitboxObject, Owner: Player, HitboxReturnData: "CharacterHit" | "All")
	local HitboxResults = {}
	local AlreadyHit = {}
	
	local OwnerCharacter = Owner.Character
	
	for _, Item: BasePart in HitboxObject do
		if OwnerCharacter and Item:IsDescendantOf(OwnerCharacter) then
			continue
		end
		
		if HitboxReturnData == "CharacterHit" then
			local Character: Model = Item.Parent
			if not Character then
				continue
			end
			if not Character:FindFirstChild("Humanoid") then
				continue
			end
			if not AlreadyHit[Character] then
				table.insert(HitboxResults, Character)
				AlreadyHit[Character] = true
				break
			end
		end
		
		if HitboxReturnData == "All" then
			if not AlreadyHit[Item] then
				table.insert(HitboxResults, Item)
				AlreadyHit[Item] = true
			end
		end
		
	end
	
	return HitboxResults
end




return HitboxService
