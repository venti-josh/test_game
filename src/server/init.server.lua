local ReplicatedStorage = game:GetService("ReplicatedStorage")

local start = require(ReplicatedStorage.Shared.start)

local world, state = start({
  script.systems,
  ReplicatedStorage.Shared.systems
})