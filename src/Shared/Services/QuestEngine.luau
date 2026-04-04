-- Same to WeaponData, this is directly under questservice
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Shared = ReplicatedStorage.SharedModules
local Types = Shared.Types
local QuestsTable = require(Types.Quests)

local QuestEngine = {}

function QuestEngine.StartQuest(PlayerData: {}, PlayerID: number, QuestID: string?)
	if not QuestsTable[QuestID] then
		print("Quest Does Not Exist")
		return
	end
	
	if not PlayerData.Quests[QuestID] then
		
		PlayerData.Quests[QuestID] = {
			ID = QuestID,
			Completed = false,
			Active = true,
			CurrentProgress = 0,
		}
		
	end
end


function QuestEngine.ProgressQuest(PlayerData: {}, PlayerID: number, Objective: string, ObjectiveTarget: string, IncrementAmount: number)
	local PlayerQuestsTable = PlayerData.Quests
	local CurrentPlayerData = PlayerData[PlayerID]
	
	for _, ActivePlayerQuests in PlayerQuestsTable do
		if not QuestsTable[ActivePlayerQuests.ID] then
			continue
		end
		
		if not ActivePlayerQuests.Active then
			continue
		end
		
		if CurrentPlayerData.CompletedQuests[ActivePlayerQuests.ID] then
			print("Player has already completed the quests")
			continue
		end
		
		local QuestID = ActivePlayerQuests.ID
		local QuestDefinition = QuestsTable[QuestID]
		local CurrentQuestObjective = QuestDefinition.Objective
		local CurrentQuestObjectiveTarget = QuestDefinition.ObjectiveTarget
		local CurrentQuestGoalAmount = QuestDefinition.GoalAmount
		
		if CurrentQuestObjective == Objective and CurrentQuestObjectiveTarget == ObjectiveTarget then
			ActivePlayerQuests.CurrentProgress += IncrementAmount
		end
		
		if ActivePlayerQuests.CurrentProgress >= CurrentQuestGoalAmount then
			print("Completed Quest")
			ActivePlayerQuests.Completed = true
			ActivePlayerQuests.Active = false
			CurrentPlayerData.CompletedQuests[QuestID] = true
		end
		
	end
end

return QuestEngine
