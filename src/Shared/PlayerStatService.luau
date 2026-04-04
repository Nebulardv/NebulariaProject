local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local RequestSignals = Events.RequestSignals
local Types = Shared.Types
local ExportedPlayerStatTypes = require(Types.PlayerStatsType)
local Data = Shared.Data

local GlobalDataDictionary = require(Data.GlobalPlayerData)

type PlayerStatsType = {[number]: ExportedPlayerStatTypes.PlayerStats}
local GlobalPlayerStats: PlayerStatsType = {}

local OnPlayerStatModifiedBindable: BindableEvent = Signals.OnPlayerStatModifiedBindable

local PlayerStatService = {}

function PlayerStatService.RegisterPlayer(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	
	GlobalDataDictionary[PlayerID].Stats = {
		MaxHealth = 100,
		DamageMultiplier = 1,
		Armor = 0,
		Speed = 16,
		JumpHeight = 7.2,
		AttackingSpeedDifference = 10,
		AttackingJumpHeightDifference = 4,
		BlockingSpeedDifference = 10,
		BlockingJumpHeightDifference = 5,
		HealthRegenRate = 10,
		MaxStamina = 100,
		StaminaRegenRate = 5,
		StaminaDrainRate = 5,
		SprintSpeedDifference = 15,
		SprintRegenDelay = 5,
		StunnedSpeedDifferenceMultiplier = 0.1,
	}
	
	print("Created Player Stats Data for: ".. tostring(PlayerID))
end

function PlayerStatService.GetPlayerStats(PlayerID: number)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	return GlobalDataDictionary[PlayerID].Stats
end

function PlayerStatService.GetIndividualStat(PlayerID: number, Stat: string)
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	if not GlobalDataDictionary[PlayerID].Stats[Stat] then
		print("No stat found")
		return
	end
	
	return GlobalDataDictionary[PlayerID].Stats[Stat]
end

function PlayerStatService.ModifyPlayerStat(PlayerID: number, Stat: string, Amount: number, Modifier: "+" | "-" | "*" | "/" | "^")
	assert(typeof(PlayerID) == "number", "PlayerID is not a number")
	if not GlobalDataDictionary[PlayerID].Stats[Stat] then
		print("No stat found")
		return
	end
	
	local StatAmount = GlobalDataDictionary[PlayerID].Stats[Stat]
	if Modifier == "+" then
		StatAmount += Amount
	elseif Modifier == "-" then
		StatAmount -= Amount
	elseif Modifier == "*" then
		StatAmount *= Amount
	elseif Modifier == "/" then
		StatAmount /= Amount
	elseif Modifier == "^" then
		StatAmount ^= Amount
	end
	
	
	GlobalDataDictionary[PlayerID].Stats[Stat] = StatAmount
	OnPlayerStatModifiedBindable:Fire(GlobalDataDictionary[PlayerID].Stats[Stat], StatAmount)
end


function PlayerStatService.Init(Player: Player?)
	if Player then
		PlayerStatService.RegisterPlayer(Player.UserId)
	else
		error("No Player Argument passed In the Init function for ModuleScript: ".. script.Name)
	end
end


return PlayerStatService
