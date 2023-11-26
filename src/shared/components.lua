local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Matter = require(ReplicatedStorage.Packages.matter)

local COMPONENTS = {
    "Model",
    "Ball",
    "Goal"
}

local components = {}

for _, name in ipairs(COMPONENTS) do
	components[name] = Matter.component(name)
end

return components
