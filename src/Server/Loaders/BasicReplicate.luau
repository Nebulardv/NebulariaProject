local Players = game:GetService("Players")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local PlayerStatService = require(Services.PlayerStatService)
local StateMachine = require(Services.StateMachine)

local Events = ReplicatedStorage.Events
local Signals = Events.Signals

local OnStateChangedRemote: RemoteEvent = Signals.OnStateChangedRemote
local OnStateChangedBindable: BindableEvent = Signals.OnStateChangedBindable

local OnPlayerStatModifiedBindable: BindableEvent = Signals.OnPlayerStatModifiedBindable
local OnPlayerStatModifiedRemote: RemoteEvent = Signals.OnPlayerStatModifiedRemote
local SendStatTableData: RemoteEvent = Signals.SendStatTableData
local SendStatesData: RemoteEvent = Signals.SendStatesData

Players.PlayerAdded:Connect(function(Player: Player)
	Player.CharacterAdded:Connect(function()
		OnPlayerStatModifiedBindable.Event:Connect(function(Player: Player, StatName: string, Value: number)
			OnPlayerStatModifiedRemote:FireClient(Player ,StatName, Value)
		end)

		OnStateChangedBindable.Event:Connect(function(NewState)
			OnStateChangedRemote:FireClient(Player ,NewState)
		end)

		local PlayerStats = PlayerStatService.GetPlayerStats(Player.UserId)
		local PlayerState = StateMachine.GetCurrentPlayerState(Player.UserId)

		SendStatTableData:FireClient(Player, PlayerStats)
		SendStatesData:FireClient(Player, PlayerState)
	end)

end)
