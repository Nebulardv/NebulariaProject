--// DISCLAIMER, THIS IS ONLY A PLACEHOLDER FOR THE FUTURE, THIS ONLY MAKES IT TAT THE PLAYERR SPAWNS WITH A KATANA FOR TESTING AND TESTS INVENTORYSERVICE DO NOT TAKE THIS SERIOUSLY PYRO AND FLOOWMI AND VE AND ROBY AND DELULULULU

local StarterPlayer = game:GetService("StarterPlayer")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Utilities = SharedModules.Utilities
local SendSignals = require(Utilities.SendSignals)

local ReplicatedStorage = game:GetService("ReplicatedStorage")


local Events = ReplicatedStorage.Events

local Players = game:GetService("Players")
local Player = Players.LocalPlayer


local RequestInventoryUpdateData = {
	RequestedItem = "Katana",
	Amount = 1,
	RequestedAction = "AddItem"
}

Player.CharacterAdded:Connect(function(Character: Model)
	if Character == Player.Character then
		SendSignals.RequestInventoryUpdateSignal(
			RequestInventoryUpdateData
		)
	end

end)
