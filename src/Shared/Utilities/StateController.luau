local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Services = Shared.Services
local PlayerStatService = require(Services.PlayerStatService)

local Types =  Shared.Types
local PlayerStatsTypeModule = require(Types.PlayerStatsType)

type PlayerStatsType  = PlayerStatsTypeModule.PlayerStats

type States = "Idle" | "Attacking" | "Dead" | "Stunned" | "Blocking" | "Sprinting" | "Walking"

type ConfigData = "AttackingSpeed" | "BlockingSpeed" | "BaseSpeed" | "AttackingJumpHeight" | "BlockingJumpHeight" | "BaseJumpHeight" | "SprintingSpeed" | "StunnedSpeed" | "NoJumpHeight" | "NoSpeed"
type ConfigFunctions = {[ConfigData]: (PlayerStats: PlayerStatsType) -> number}

type StateConfigurationsType = {
	[States]: {
		["WalkSpeed"]: ConfigData,
		["JumpHeight"]: ConfigData
	}
}

local StateConfigurations: StateConfigurationsType = {
	["Attacking"] = {
		["WalkSpeed"] = "AttackingSpeed",
		["JumpHeight"] = "AttackingJumpHeight",
	},
	["Blocking"] = {
		["WalkSpeed"] = "BlockingSpeed",
		["JumpHeight"] = "BlockingJumpHeight",
	},
	["Sprinting"] = {
		["WalkSpeed"] = "SprintingSpeed",
		["JumpHeight"] = "BaseJumpHeight",
	},
	["Stunned"] = {
		["WalkSpeed"] = "StunnedSpeed",
		["JumpHeight"] = "NoJumpHeight",
	},
	["Idle"] = {
		["WalkSpeed"] = "BaseSpeed",
		["JumpHeight"] = "BaseJumpHeight",
	},
	["Walking"] = {
		["WalkSpeed"] = "BaseSpeed",
		["JumpHeight"] = "BaseJumpHeight",
	},
	["Dead"] = {
		["WalkSpeed"] = "NoSpeed",
		["JumpHeight"] = "NoJumpHeight",
	},
}

local StateController = {}

local ConfigurationFunctions: ConfigFunctions = {
	["AttackingSpeed"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.Speed - PlayerStats.AttackingSpeedDifference
	end,
	["SprintingSpeed"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.Speed + PlayerStats.SprintSpeedDifference
	end,
	["BlockingSpeed"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.Speed - PlayerStats.BlockingSpeedDifference
	end,
	["BaseSpeed"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.Speed
	end,
	["StunnedSpeed"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.Speed * PlayerStats.StunnedSpeedDifferenceMultiplier
	end,
	["NoSpeed"] = function(PlayerStats: PlayerStatsType)
		return 0
	end,

	["BaseJumpHeight"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.JumpHeight
	end,
	["AttackingJumpHeight"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.JumpHeight - PlayerStats.AttackingJumpHeightDifference
	end,
	["BlockingJumpHeight"] = function(PlayerStats: PlayerStatsType)
		return PlayerStats.JumpHeight - PlayerStats.BlockingJumpHeightDifference
	end,
	["NoJumpHeight"] = function(PlayerStats: PlayerStatsType)
		return 0
	end,
}

function StateController.ApplyState(Player: Player, State: string)
	local PlayerStats = PlayerStatService.GetPlayerStats(Player.UserId)
	
	
	local Character = Player.Character
	local Humanoid: Humanoid = Character.Humanoid
	if not Character or not Humanoid then
		print("No Humanoid and No character found")
		return
	end
	
	local StateSpeedType: ConfigData = StateConfigurations[State]["WalkSpeed"]
	local StateJumpHeightType: ConfigData = StateConfigurations[State]["JumpHeight"]
	
	print(StateSpeedType)
	local DecidedSpeed = ConfigurationFunctions[StateSpeedType](PlayerStats)
	local DecidedJumpHeight = ConfigurationFunctions[StateJumpHeightType](PlayerStats)
	
	Humanoid.WalkSpeed = DecidedSpeed
	Humanoid.JumpHeight = DecidedJumpHeight
end

return StateController
