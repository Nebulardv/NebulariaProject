local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local SharedModules = ReplicatedStorage.SharedModules
local Services = SharedModules.Services
local TypesFolder = SharedModules.Types
local UtilsShared = SharedModules.Utilities

local Assets = ReplicatedStorage.Assets
local VFX = Assets.VFX
local Sounds = Assets.Sounds

local SendSignals = require(UtilsShared.SendSignals)
local WeaponDataTypes = require(TypesFolder.WeaponDataTypes)
local InventoryService = require(Services.InventoryService)
local EquipService = require(Services.EquipService)
local StateMachine = require(Services.StateMachine)
local PlayerStatService = require(Services.PlayerStatService)
local WeaponData = require(Services.EquipService.WeaponData)
local CombatService = require(Services.CombatService)
local DamageService = require(Services.DamageService)
local MovementService = require(Services.MovementService)

local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local RequestSignals = Events.RequestSignals
local RequestInventoryUpdateSignal: RemoteEvent = RequestSignals.RequestUpdateInventory
local RequestWeaponHandlerSignal: RemoteEvent = RequestSignals.RequestWeaponHandler
local RequestStateTransitionSignal: RemoteEvent = RequestSignals.RequestStateTransition
local RequestStatModification: RemoteEvent = RequestSignals.RequestStatModification
local RequestAttackSignal: RemoteEvent = RequestSignals.RequestAttack

type AvailableStates = "Idle" | "Attacking" | "Dead" | "Stunned" | "Blocking"
type Modifiers =  "+" | "-" | "*" | "/" | "^"
type RequestedActions = "AddItem" | "RemoveItem" | "ClearInventory"
type WeaponOptions = "Equip" | "Unequip"


local RecievedSignals = {}

function RecievedSignals.RecieveInventoryUpdateRequestSignal()
	RequestInventoryUpdateSignal.OnServerEvent:Connect(function(
		Player: Player,
		RequestedInventoryUpdateData: {
			RequestedItemName: string,
			Amount: number,
			RequestedAction: RequestedActions
		}
	)
		
		if RequestedInventoryUpdateData.RequestedAction == "AddItem" then
			InventoryService.AddToInventory(
				Player.UserId,
				RequestedInventoryUpdateData.RequestedItem,
				RequestedInventoryUpdateData.Amount
			)
		elseif RequestedInventoryUpdateData.RequestedAction == "RemoveItem" then
			InventoryService.RemoveFromInventory(
				Player.UserId,
				RequestedInventoryUpdateData.RequestedItem,
				RequestedInventoryUpdateData.Amount
			)
		elseif RequestedInventoryUpdateData.RequestedAction == "ClearInventory" then
			InventoryService.ClearInventory(Player.UserId)
		end
	end)
end

function RecievedSignals.RecieveWeaponHandlerRequestSignal()
	RequestWeaponHandlerSignal.OnServerEvent:Connect(function(
		Player: Player,
		RequestedAction: WeaponOptions
	)
		
		local Character = Player.Character
		if not Character then
			return
		end
		local EquippedWeapon
		for _, Item in Character:GetChildren() do
			if Item:IsA("Tool") then
				local Weapon = Character:FindFirstChild(Item.Name)

				if not Weapon then
					print("No Weapon Found")
					return
				end
				EquippedWeapon = Weapon.Name
			end
		end

		local currentWeaponData = WeaponData[EquippedWeapon]
		if RequestedAction == "Equip" then

			EquipService.EquipWeapon(Player, Character, currentWeaponData.WeaponName, currentWeaponData)
		elseif RequestedAction == "Unequip" then
			EquipService.UnequipWeapon(Player, Character)
		end
	end)
end

function RecievedSignals.RecieveRequestStateTransitionSignal()
	RequestStateTransitionSignal.OnServerEvent:Connect(function(
		Player: Player,
		RequestedStateTransition: AvailableStates
	)
		
		StateMachine.TransitionPlayerState(Player.UserId, RequestedStateTransition)
	end)
end

function RecievedSignals.RecieveStatModificationRequest()
	RequestStatModification.OnServerEvent:Connect(function(
		Player: Player,
		RequestStatModificationData: {
			StatToModify: string,
			Amount: number,
			Modifier: Modifiers
		}
	)
		PlayerStatService.ModifyPlayerStat(
			Player.UserId,
			RequestStatModificationData.StatToModify,
			RequestStatModificationData.Amount,
			RequestStatModificationData.Modifier
		)
	end)
end

function RecievedSignals.RecieveAttackRequest()
	RequestAttackSignal.OnServerEvent:Connect(function(
		Player: Player,
		TargetCharacter: Model,
		HitboxSize: Vector3
	)
		local PlayerID = Player.UserId
		local EquippedWeapon = EquipService.GetEquippedWeapon(PlayerID)
		if not EquippedWeapon  then
			print("No Equipped Weapon")
			return
		end
		local EquippedWeaponData = WeaponData[EquippedWeapon]
		if not EquippedWeaponData then
			print("No Equipped Weapon Data")
			return
		end
		local WeaponName = EquippedWeaponData.WeaponName
		
		if not TargetCharacter then
			return
		end
		local PlayerID = Player.UserId
		local PlayerCharacter: Model = Player.Character
		local PlayerHumanoidRootPart: BasePart = PlayerCharacter:FindFirstChild("HumanoidRootPart")

		local TargetHumanoid: Humanoid = TargetCharacter:FindFirstChild("Humanoid")
		local TargetHumanoidRootPart: BasePart = TargetCharacter:FindFirstChild("HumanoidRootPart")
		if not TargetHumanoid or not TargetHumanoidRootPart then
			return
		end
		
		local WeaponVFXFolder = VFX[WeaponName]
		if not WeaponVFXFolder then
			print("No Weapon VFX folder found")
			return
		end
		
		local BloodHitVFX: Attachment = WeaponVFXFolder:FindFirstChild("BloodHit")
		if not BloodHitVFX then
			print("BloodHitVFX not found")
			return
		end
		local ParticleEmitters:ParticleEmitter = BloodHitVFX:GetChildren()
		if not ParticleEmitters then
			print("Particle Emitters not found")
			return
		end
		
		local EmitCount
		for _, ParticleEmitter in ParticleEmitters do
			EmitCount = ParticleEmitter:GetAttribute("EmitCount")
			if not EmitCount then
				return
			end
		end
		local WeaponSoundsFolder = Sounds[WeaponName]
		if not WeaponSoundsFolder then
			print("Weapon Sounds Folder not found")
			return
		end
		local HitSound = WeaponSoundsFolder[WeaponName.."HitSound"]
		if not HitSound then
			print("Hit Sound not found")
		end
		
		
		local VFXposition = TargetHumanoidRootPart.Position
		CombatService.ProcessHit(
			PlayerID,
			PlayerCharacter,
			PlayerHumanoidRootPart,
			TargetCharacter,
			TargetHumanoid,
			TargetHumanoidRootPart,
			WeaponName,
			HitboxSize
		)
		SendSignals.SendEffectsToAllClients(
			TargetCharacter,
			BloodHitVFX,
			VFXposition,
			1
		)
		SendSignals.SendSoundEffectdToAllClients(
			HitSound,
			TargetCharacter
		)
		

	end)
end



function RecievedSignals.Init(Player: Player?)
	RecievedSignals.RecieveAttackRequest()
	RecievedSignals.RecieveInventoryUpdateRequestSignal()
	RecievedSignals.RecieveWeaponHandlerRequestSignal()
	RecievedSignals.RecieveRequestStateTransitionSignal()
	RecievedSignals.RecieveStatModificationRequest()
end

return RecievedSignals
