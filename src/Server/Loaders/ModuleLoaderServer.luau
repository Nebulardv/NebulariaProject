local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ServerModules = script.Parent.Parent.ServerModules
local ModuleLoader = require(ServerModules.ModuleLoader)
local SharedModules = ReplicatedStorage.SharedModules
local Utilities = SharedModules.Utilities

local RecievedSignalsModule = require(Utilities.RecievedSignals)

Players.PlayerAdded:Connect(function(Player: Player)
	ModuleLoader.LoadModules(
		Player
	)
	RecievedSignalsModule.Init(Player)
end)
