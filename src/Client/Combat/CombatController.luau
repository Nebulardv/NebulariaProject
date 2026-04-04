local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local SharedModules = ReplicatedStorage.SharedModules
local Services = SharedModules.Services
local Events = ReplicatedStorage.Events
local UtilsShared = SharedModules.Utilities

local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer.StarterPlayerScripts
local ClientScripts = StarterPlayerScripts.Client
local UtilsClient = ClientScripts.Util

local EquipService = Services.EquipService
local WeaponData = require(EquipService.WeaponData)
local StateMachine = require(Services.StateMachine)
local HitboxService = require(Services.HitboxService)
local SendSignals = require(UtilsShared.SendSignals)
local AnimationService = require(Services.AnimationService)
local EffectsService = require(Services.EffectsService)



local Assets = ReplicatedStorage.Assets
local VFX = Assets.VFX
local Sounds = Assets.Sounds
local Events = ReplicatedStorage.Events


local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart: BasePart = Character:WaitForChild("HumanoidRootPart")
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")

local ClientCombatState = {}

ClientCombatState[Player] = {
	ComboStep = 0,
	LastAttackTime = 0,
}

local ComboResetTime = 1.6-- This is a static value for now, but can be made dynamic in the future if needed
local AttackKey = Enum.UserInputType.MouseButton1
local StateResetToIdleTime = 0.5


local HitboxParams = OverlapParams.new()
HitboxParams.FilterType = Enum.RaycastFilterType.Exclude
HitboxParams.FilterDescendantsInstances = {Character}

local function GetEquippedWeapon(Character: Model)
	for _, Item in Character:GetChildren()  do
		if Item:IsA("Tool") then
			local EquippedWeapon = Character:FindFirstChild(Item.Name)
			if not EquippedWeapon then
				return
			end
			return EquippedWeapon
		end
	end
end

local function GetHitboxData(HitboxObj, HitTargets)
	local Hits = HitboxService.GetHitboxData(HitboxObj, Player, "CharacterHit")
	for _, HitItem in Hits do
		if not HitTargets[HitItem] then
			HitTargets[HitItem] = true
			return HitItem
		end
		
	end
end

UserInputService.InputBegan:Connect(function(Input: InputObject, GameProcessed: boolean)

	if GameProcessed then
		return
	end
	
	local EquippedWeapon = GetEquippedWeapon(Character)
	if not EquippedWeapon then
		return
	end
	if Input.UserInputType == AttackKey then
		
		
	
		local HitTargets = {}
		local EquippedWeaponName = EquippedWeapon.Name
		
		local EquippedWeaponData = WeaponData[EquippedWeaponName]
		if not EquippedWeaponData then
			print("Weapon Does Not have WeaponData")
		end
		

		
		local AttackIntervalCooldownTime = EquippedWeaponData.AttackIntervalCooldown
		local AttackCooldownTime: number = EquippedWeaponData.WeaponAttackCooldown
		local Now = os.clock()
	
		if Now - ClientCombatState[Player].LastAttackTime > ComboResetTime then
			ClientCombatState[Player].ComboStep = 0
		end
		if ClientCombatState[Player].ComboStep >= 4 then
			if Now - ClientCombatState[Player].LastAttackTime < ComboResetTime then
				return
			end
		end
		if Now - ClientCombatState[Player].LastAttackTime < AttackIntervalCooldownTime then
			return
		end
		
		
		ClientCombatState[Player].ComboStep += 1
		ClientCombatState[Player].LastAttackTime = Now
		
	
		local AttackAnimationKeyName = "M"..ClientCombatState[Player].ComboStep
		local AttackAnimations = EquippedWeaponData.AttackAnims
		if not AttackAnimations then
			print("Weapon Does Not have AttackAnims")
			return
		end
		local AttackAnimation: Animation = AttackAnimations[AttackAnimationKeyName]
		
		if not AttackAnimation then
			print("AttackAnimation Does Not Exist")
			return
		end
		
		if ClientCombatState[Player].ComboStep > EquippedWeaponData.MaxCombo then
			ClientCombatState[Player].ComboStep = 1
		end
		local HitboxSize = EquippedWeaponData.WeaponHitboxData.Size
		local HitboxLifetime = EquippedWeaponData.WeaponHitboxData.HitboxLifetime
		
	

		local WeaponSounds: Folder = Sounds[EquippedWeaponName]
		local SwingSound: Sound = WeaponSounds:WaitForChild("Swing")
		local SwingSoundClone = SwingSound:Clone()
		

		AnimationService.OnMarkerReached(Character, AttackAnimation.Name,"Impact", function()
			local HitboxCFrame = HumanoidRootPart.CFrame * EquippedWeaponData.WeaponHitboxData.CFrameOffset
			local HitboxObj = HitboxService.CreateHitbox(
				HitboxCFrame,
				HitboxSize,
				HitboxParams
			)
			local TargetCharacter: Model = GetHitboxData(HitboxObj, HitTargets)
			SendSignals.RequestAttack(
				TargetCharacter,
				HitboxSize
			)
			--[[SendSignals.RequestStateTransition(
				"Attacking"
			)]]
			
			SendSignals.RequestStateTransition(
				"Attacking"
			)
			
		
			--[[HitboxService.VisualizeHitbox(
				HitboxCFrame,
				HitboxSize,
				0.2
			)]]


			EffectsService.PlaySoundEffects(SwingSoundClone, Character)

		end)
		
		local AnimTrack: AnimationTrack = AnimationService.PlayAnimation(
			Character,
			AttackAnimation.Name
		)
	end
end)


UserInputService.InputEnded:Connect(function(Input:InputObject,Gpe:boolean)
	if Gpe then
		return
	end
	if Input.KeyCode == AttackKey then
		SendSignals.SendInputStatesCondition(
			{ IsAttacking = false }
		)
	end
end)
