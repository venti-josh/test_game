--|| Services ||--
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--|| Packages ||--
local Packages = ReplicatedStorage.Packages
local Matter = require(Packages.matter)
local HotReloader = require(Packages.rewire).HotReloader

local components = require(script.Parent.components)

local function start(containers)
    local world = Matter.World.new()
    local state = {}

    local loop = Matter.Loop.new(world, state)

    -- Setup hot reloading
    local hotReloader = HotReloader.new()

    local firstRunSystems = {}
    local systemsByModule = {}

    local function loadModule(module, context)
        local originalModule = context.originalModule

        local ok, system = pcall(require, module)

        if not ok then
            warn("Error when hot-reloading system", module.name, system)
            return
        end

        if firstRunSystems then
            table.insert(firstRunSystems, system)
        elseif systemsByModule[originalModule] then
            loop:replaceSystem(systemsByModule[originalModule], system)
        else
            loop:scheduleSystem(system)
        end

        systemsByModule[originalModule] = system
    end

    local function unloadModule(_, context)
        if context.isReloading then
            return
        end

        local originalModule = context.originalModule
        if systemsByModule[originalModule] then
            loop:evictSystem(systemsByModule[originalModule])
            systemsByModule[originalModule] = nil
        end
    end

    for _, container in containers do
        hotReloader:scan(container, loadModule, unloadModule)
    end

    loop:scheduleSystems(firstRunSystems)
    firstRunSystems = nil

    -- Begin running our systems

    loop:begin({
        default = RunService.Heartbeat,
        Stepped = RunService.Stepped,
    })

    return world, state
end

return start