local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Services = SharedModules.Services
local Utilities = SharedModules.Utilities
local SendSignals = require(Utilities.SendSignals)

local EquipServiceModule = require(Services.EquipService)

local Players = game:GetService("Players")
local Client = Players.LocalPlayer
local Character = Client.Character or Client.CharacterAdded:Wait()

local WeaponDataDictionary = require(Services.EquipService.WeaponData)

local Registered = {}

local function HandleWeapon(Weapon: Tool)
	
	local ToolWeaponName = Weapon.Name
	local WeaponData = WeaponDataDictionary[ToolWeaponName]
	if not WeaponData then
		return
	end
	local WeaponName = WeaponData.WeaponName
	
	if Weapon:IsA("Tool") then
		Weapon.Equipped:Connect(function()
			SendSignals.RequestWeaponHandlerSignal(
				"Equip"
			)
			print("Equipped: ".. WeaponName)
		end)
		
		Weapon.Unequipped:Connect(function()
			print("Unequipped: ".. Weapon.Name)
			SendSignals.RequestWeaponHandlerSignal(
				"Unequip"
			)
		end)
	end
end

for _, Weapon in pairs(Client.Backpack:GetChildren()) do
	HandleWeapon(Weapon)
	table.insert(Registered, Weapon)
end

Character.ChildAdded:Connect(function(NewWeapon)
	if table.find(Registered, NewWeapon) then
		return
	end
	table.insert(Registered, NewWeapon)
	HandleWeapon(NewWeapon)
end)

Client.Backpack.ChildAdded:Connect(function(NewWeapon)
	if table.find(Registered, NewWeapon) then
		return
	end
	table.insert(Registered, NewWeapon)
	HandleWeapon(NewWeapon)
end)

Client.CharacterAdded:Connect(function()
	HandleWeapon()
end)
