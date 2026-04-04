--// EXTREMELY HEAVY WIP 
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local Services = SharedModules.Services
local Utils = SharedModules.Utilities

local StateMachine = require(Services.StateMachine)
local AnimationService = require(Services.AnimationService)

local Runservice = game:GetService("RunService")


local PlayerStatService = require(Services.PlayerStatService)
local SendSignals = require(Utils.SendSignals)

local Connection

local MovementService = {}

function MovementService.BeginSprint(Player: Player)
	local PlayerID = Player.UserId
	local Character = Player.Character
	local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
	
	local PlayerStats = PlayerStatService.GetPlayerStats(PlayerID)
	
	local MaxStamina = PlayerStats.MaxStamina
	local StaminaDrainRate = PlayerStats.StaminaDrainRate
	local StaminaRegenRate = PlayerStats.StaminaRegenRate
	
	local Stamina = Player:GetAttribute("Stamina")

end

return MovementService
