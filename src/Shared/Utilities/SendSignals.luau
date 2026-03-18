--[[
	By @nebulardv[socials], @strb575[roblox]
	
	Simple module to simplify singal firing to the server.	
	
	Signals denoted via variables
	Module functions simplify sending signals to server where server does
	Validation and the action
	
	Example Usage: 
	SendSignals.RequestInventoryUpdateSignal("Sword", 1, "AddItem")
	
	Server:
	On Signal Event, Validates RequestedItemName and Amount, then
	Does action on player's inventory

]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local CombatModules = SharedModules.Combat
local TypesFolder = CombatModules.Types
local WeaponDataTypes = require(TypesFolder.WeaponDataTypes)

type WeaponDataTableType = WeaponDataTypes.WeaponData

local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local RequestSignals = Events.RequestSignals
local RequestInventoryUpdateSignal: RemoteEvent = RequestSignals.RequestUpdateInventory
local RequestWeaponHandlerSignal: RemoteEvent = RequestSignals.RequestWeaponHandler
local RequestStateTransitionSignal: RemoteEvent = RequestSignals.RequestStateTransition
local RequestStatModification: RemoteEvent = RequestSignals.RequestStatModification


local SendSignals = {}

function SendSignals.RequestInventoryUpdateSignal(
	RequestedItemName: string,
	Amount: number,
	RequestedAction: "AddItem" | "RemoveItem" | "ClearInventory"
	
)
	
	if not RequestInventoryUpdateSignal then
		print(RequestInventoryUpdateSignal.." Not Found")
		return
	end
	RequestInventoryUpdateSignal:FireServer(
		RequestedItemName,
		Amount,
		RequestedAction
	)
end

function SendSignals.RequestWeaponHandlerSignal(
	RequestedAction: "Equip" | "Unequip"
)
	
	if not RequestWeaponHandlerSignal then
		print(RequestWeaponHandlerSignal.." Not Found")
		return
	end
	RequestWeaponHandlerSignal:FireServer(
		RequestedAction
	)
end

function SendSignals.RequestStateTransition(
	RequestedState: string
)
	
	if not RequestStateTransitionSignal then
		print(RequestStateTransitionSignal .." Not Found")
		return
	end
	RequestStateTransitionSignal:FireServer(
		RequestedState
	)
end

function SendSignals.RequestStatModification(
	StatToModify: string,
	Amount: number,
	Modifier: "+" | "-" | "*" | "/" | "^"
)

	if not RequestStatModification then
		print(RequestStatModification .." Not Found")
		return
	end
	RequestStateTransitionSignal:FireServer(
		StatToModify,
		Amount,
		Modifier
	)
end


return SendSignals
