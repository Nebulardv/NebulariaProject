local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local PlayerStatService = require(Services.PlayerStatService)
local StateMachine = require(Services.StateMachine)

local DamageService = {}

function DamageService.GetPlayerDamage(PlayerID: number)
	local PlayerStats = PlayerStatService.GetPlayerStats(PlayerID)
	if not PlayerStats then
		return
	end
	return PlayerStats.Damage
end

function DamageService.DealDamage(TargetCharacter: Model, TargetHumanoid: Humanoid, Damage: number)
	local Targetplayer = Players:GetPlayerFromCharacter(TargetCharacter)
	if not Targetplayer then
		TargetHumanoid:TakeDamage(Damage)
		return
	end
	local TargetID = Targetplayer.UserId
	
	local TargetPlayerStats = PlayerStatService.GetPlayerStats(TargetID)
	if not TargetPlayerStats then
		return
	end

	local DamageDealt = Damage - TargetPlayerStats.Armor
	if DamageDealt < 0 then
		DamageDealt = 0
	end
	assert(typeof(TargetID) == "number", "TargetID is not a number")
	
	if StateMachine.IsInState(TargetID, "Dead") then
		print("Player is Dead")
		return
	end
	
	if not TargetID or not TargetHumanoid:IsA("Humanoid") then
		return
	end
	

	TargetHumanoid:TakeDamage(DamageDealt)
end

function DamageService.DamageNPC(TargetCharacter: Model, Damage: number)
	if not TargetCharacter then
		return
	end
	local TargetHumanoid = TargetCharacter:FindFirstChildOfClass("Humanoid")
	if not TargetHumanoid then
		return
	end
	TargetHumanoid:TakeDamage(Damage)
end

function DamageService.HealPlayer(TargetID: number, TargetHumanoid: Humanoid, Amount: number)
	local TargetPlayerStats = PlayerStatService.GetPlayerStats(TargetID)
	assert(typeof(TargetID) == "number", "TargetID is not a number")
	
	if not TargetHumanoid:IsA("Humanoid") then
		return
	end
	
	if Amount < 0 then
		Amount = 0
	end
	if Amount + TargetHumanoid.Health > TargetHumanoid.MaxHealth then
		TargetHumanoid.Health = TargetHumanoid.MaxHealth
		return
	end
	TargetHumanoid.Health += Amount
end

function DamageService.GetDamageTaken(TargetHumanoid: Humanoid)
	return TargetHumanoid.MaxHealth - TargetHumanoid.Health
end


return DamageService
