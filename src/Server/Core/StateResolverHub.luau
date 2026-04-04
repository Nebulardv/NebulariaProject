local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local Utilities =Shared.Utilities

local StateResolver = require(Services.StateMachine.StateResolver)
local PlayerStateConditions  = require(Services.StateMachine.PlayerStateConditions)
local StateController = require(Utilities.StateController)

local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local SendInputStateCondition = Signals.SendInputStateCondition
local OnStateChangedBindable: BindableEvent = Signals.OnStateChangedBindable

local Players = game:GetService("Players")


SendInputStateCondition.OnServerEvent:Connect(function(
	Player: Player,
	StateConditions
)
	
	PlayerStateConditions.UpdateConditions(Player, StateConditions)
	
	local CurrentConditions = PlayerStateConditions.GetConditions(Player)
	StateResolver.ResolveState(CurrentConditions, Player)
end)


Players.PlayerAdded:Connect(function(Player: Player)
	PlayerStateConditions.RegisterPlayerConditions(Player)
	
	OnStateChangedBindable.Event:Connect(function(NewPlayerState)
		StateController.ApplyState(Player, NewPlayerState)
	end)
end)
