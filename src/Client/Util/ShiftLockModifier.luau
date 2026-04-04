local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer

local ShiftLockKey = "LeftControl" 

local PlayerScripts = localPlayer:WaitForChild("PlayerScripts")
local PlayerModule = PlayerScripts:WaitForChild("PlayerModule")
local CameraModule = PlayerModule:WaitForChild("CameraModule")
local MouseLockController = CameraModule:WaitForChild("MouseLockController")

local boundKeys = MouseLockController:FindFirstChild("BoundKeys")

if not boundKeys then
	boundKeys = Instance.new("StringValue")
	boundKeys.Name = "BoundKeys"
	boundKeys.Parent = MouseLockController
end

boundKeys.Value = ShiftLockKey
