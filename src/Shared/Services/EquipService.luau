
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")

local AssetsFolder = ReplicatedStorage.Assets
local WeaponsFolder = AssetsFolder.Weapons
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local TypesFolder = Shared.Types
local ExportedWeaponDataTypes = require(TypesFolder.WeaponDataTypes)
local WeaponData = require(Services.EquipService.WeaponData)
local EquippedWeapons = {}

local EquipService = {}

function EquipService.EquipWeapon(Player: Player, Character: Model, WeaponName: string, WeaponData : ExportedWeaponDataTypes.WeaponData)
	if not Player or not Character then
		print(" Player Or Character Does not exist")
		return
	end
	
	local WeaponModel = WeaponsFolder:WaitForChild(WeaponName)
	if not WeaponModel then
		print("WeaponModel Does Not Exist")
		return
	end
	local RightArm = Character:WaitForChild("Right Arm")
	if not RightArm then
		print("Right Arm Does Not Exist")
		return
	end
	
	local ActualWeaponClone = WeaponModel[WeaponName]:Clone()
	local Handle = ActualWeaponClone:FindFirstChild("Handle")
	if not Handle then
		print("Weapon Handle Does Not Exist")
		return
	end
	
	ActualWeaponClone.Parent = Character
	
	
	local Motor6D = Instance.new("Motor6D")
	Motor6D.C0 = WeaponData.EquipWeaponData.AttachCframe
	Motor6D.Part0 = RightArm
	Motor6D.Part1 = Handle
	Motor6D.Parent = RightArm
	
	EquippedWeapons[Player.UserId] = WeaponName

end

function EquipService.UnequipWeapon(Player: Player, Character: Model)
	if not Player or not Character then
		print(" Player Or Character Does not exist")
		return
	end
	
	local EquippedWeapon = EquippedWeapons[Player.UserId]
	if not EquippedWeapon then
		print("Player Has no equipped Weapons")
		return
	end
	
	local EquippedWeaponData = WeaponData[EquippedWeapon]
	local PhysicalWeapon = Character:FindFirstChild(EquippedWeapon)
	
	PhysicalWeapon:Destroy()
	EquippedWeapons[Player.UserId] = nil
end

function EquipService.GetEquippedWeapon(PlayerID: number)
	return EquippedWeapons[PlayerID]
end

return EquipService
