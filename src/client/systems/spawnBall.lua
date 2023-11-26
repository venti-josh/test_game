local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Components = require(ReplicatedStorage.Shared.components)
local Matter = require(ReplicatedStorage.Packages.matter)

local function spawnBall(world)
  local player = Players.LocalPlayer
  for  _, character in Matter.useEvent(player, "CharacterAdded") do 
    local model = ReplicatedStorage.Ball:Clone()
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    -- Calculate the position in front of the player
    local forwardVector = rootPart.CFrame.LookVector
    local distance = 5 -- Distance in studs from the player
    model.Position = rootPart.Position + forwardVector * distance
    model.Parent = workspace
  end
end

return spawnBall