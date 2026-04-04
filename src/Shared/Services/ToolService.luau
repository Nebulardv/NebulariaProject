local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Events = ReplicatedStorage.Events
local Signals = Events.Signals
local OnItemAdded: BindableEvent = Signals.OnItemAdded
local OnItemRemoved: BindableEvent = Signals.OnItemRemoved
local OnInventoryCleared: BindableEvent = Signals.OnInventoryCleared
local Assets = ReplicatedStorage.Assets
local Tools = Assets.Tools

local SharedModules = ReplicatedStorage.SharedModules
local Services = SharedModules.Services
local InventoryService = require(Services.InventoryService)

local ToolService = {}

OnItemAdded.Event:Connect(function(PlayerID, ItemName, Amount: number)
	local CurrentPlayer = Players:GetPlayerByUserId(PlayerID)
	ToolService.AddTool(CurrentPlayer, ItemName, Amount)
end)
OnItemRemoved.Event:Connect(function(PlayerID, ItemName, Amount)
	local CurrentPlayer = Players:GetPlayerByUserId(PlayerID)
	ToolService.RemoveTool(CurrentPlayer, ItemName, Amount)
end)
OnInventoryCleared.Event:Connect(function(PlayerID)
	local CurrentPlayer = Players:GetPlayerByUserId(PlayerID)
	ToolService.ClearTools(CurrentPlayer)
end)

function ToolService.AddTool(Player: Player, ToolName: string)
	if not Tools[ToolName] then
		print("Tool Does Not Exist in Game")
		return
	end
	local NewTool: Tool = Tools[ToolName]:Clone()

	NewTool.Parent = Player:WaitForChild("Backpack")

end


function ToolService.RemoveTool(Player: Player, ToolName: string, Amount: number)
	if not Tools[ToolName] then
		print("Tool Does Not Exist in Game")
		return
	end
	
	local Tool: Tool = Player:WaitForChild("Backpack"):WaitForChild(ToolName)
	if not Tool then
		print("Tool Does Not Exist in Backpack")
		return
	end
	Tool:Destroy()

end


function ToolService.SyncAllTools(PlayerID: number)
	local Player = Players:GetPlayerByUserId(PlayerID)
	local PlayerInventory = InventoryService.GetInventory(PlayerID)
	if not PlayerInventory then
		print("Player Does Not Have an Inventory")
		return
	end
	for ItemName, Amount in PlayerInventory do
		ToolService.AddTool(Player, ItemName)
	end
end

function ToolService.HasEquipped(Tool: Tool, Player: Player)
	local Character = Player.Character or Player.CharacterAdded:Wait()
	if Tool.Parent == Character then
		return true
	else
		return false
	end
end

function ToolService.GetCurrentTools(Player: Player)
	local CurrentTools = {}
	for _, Tool: Tool in Player.Backpack:GetChildren() do
		if Tool:IsA("Tool") then
			table.insert(CurrentTools, Tool)
		end
	end
	return CurrentTools
end

function ToolService.ClearTools(Player: Player)
	for _, Tool: Tool in Player.Backpack:GetChildren() do
		if Tool:IsA("Tool") then
			Tool:Destroy()
		end
	end
	ToolService.SyncAllTools(Player.UserId)

	
end

return ToolService
