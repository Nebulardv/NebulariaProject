local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local OnItemAdded: BindableEvent = Signals.OnItemAdded
local OnItemRemoved: BindableEvent = Signals.OnItemRemoved
local OnInventoryCleared: BindableEvent = Signals.OnInventoryCleared

local Shared = ReplicatedStorage.SharedModules
local Data = Shared.Data
local GlobalPlayerDataDictionary = require(Data.GlobalPlayerData)

local InventoryService = {}

function InventoryService.CreatePlayerInventory(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	
	if not GlobalPlayerDataDictionary[PlayerID].Inventory then
		GlobalPlayerDataDictionary[PlayerID].Inventory = {}
	end
	
	print("Created Player Inventory for: ".. tostring(PlayerID))
end

function InventoryService.AddToInventory(PlayerID: number, ItemName: string, Amount: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	assert(typeof(ItemName) == "string", "ItemName is not a string")
	
	if not GlobalPlayerDataDictionary[PlayerID] then
		print("Player Does not have Data")
		return
	end
	
	if not GlobalPlayerDataDictionary[PlayerID].Inventory then
		print("Player Does not have Inventory Data")
		return
	end
	
	if not GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] then
		GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] = Amount
	else
		GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] += Amount
	end
	
	OnItemAdded:Fire(PlayerID, ItemName, Amount)
	
	print("Added Item To Inventory: ".. ItemName)
	
end

function InventoryService.RemoveFromInventory(PlayerID: number, ItemName: string, Amount: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	assert(typeof(ItemName) == "string", "ItemName is not a string")
	
	if not GlobalPlayerDataDictionary[PlayerID].Inventory then
		print("Player Does not have an Inventory")
		return
	end
	
	if not GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] then
		return
	end
	
	GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] -= Amount
	if GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] <= 0 then
		GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] = nil
	end
	OnItemRemoved:Fire(PlayerID, ItemName, Amount)
end

function InventoryService.GetInventory(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	return GlobalPlayerDataDictionary[PlayerID].Inventory
end

function InventoryService.HasItem(PlayerID: number, ItemName: string)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	assert(typeof(ItemName) == "string", "ItemName is not a string")
	if not GlobalPlayerDataDictionary[PlayerID].Inventory then
		print("Player Does not have an Inventory")
		return
	end
	
	if not GlobalPlayerDataDictionary[PlayerID].Inventory[ItemName] then
		return false
	end
	return true
end


function InventoryService.ClearInventory(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	GlobalPlayerDataDictionary[PlayerID].Inventory = {}
	OnInventoryCleared:Fire(PlayerID)
	print("Cleared Player Inventory for: ".. tostring(PlayerID))
end

function InventoryService.Init(Player: Player?)
	if Player then
		InventoryService.CreatePlayerInventory(Player.UserId)
	else
		error("No Player Argument passed In the Init function for ModuleScript: ".. script.Name)
	end
end

return InventoryService
