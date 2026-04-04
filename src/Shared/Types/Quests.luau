--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Types = Shared.Types

local ExportedQuestsTypeModule = require(Types.QuestsType)

type QuestsType = ExportedQuestsTypeModule.Quests

local QuestsTable: QuestsType = {
	["Quest 1"] = {
		ID = "Quest 1",
		GoalAmount = 5,
		Reward = 100,
		Objective = "Kill",
		ObjectiveTarget = "Bandits",
		Description = "Kill 5 Bandits",
		CompletedText = "Completed Quest 1: Kill 5 Bandits"

	},
	["Quest 2"] = {
		ID = "Quest 2",
		GoalAmount = 15,
		Reward = 300,
		Objective = "Collect",
		ObjectiveTarget = "Leaves",
		Description = "Collect 15 Leaves",
		CompletedText = "Completed Quest 2: Collect 15 Leaves"
	},
	["Quest 3"] = {
		ID = "Quest 3",
		GoalAmount = 25,
		Reward = 600,
		Objective = "Open",
		ObjectiveTarget = "Chests",
		Description = "Open 25 Chests",
		CompletedText = "Completed Quest 3: Open 25 Chests"
	},
}

return QuestsTable
