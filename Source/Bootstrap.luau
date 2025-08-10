local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Toasty = script.Parent
local Util = require(script.Parent.Util)
local SingletonManager = require(ReplicatedStorage.Packages.Toasty.Core.SingletonManager)
local LifecycleManager = require(Toasty.Core.LifecycleManager)

--[=[
	@class Bootstrap
]=]

--[=[
	@function LoadModules
	@within Bootstrap
	@param parent Instance
	@param recursive boolean
	
	Calls require on all modules scripts parented under the passed parent instance
]=]
local function LoadModules(parent: Instance, recursive: boolean)
	local possibleModules = if recursive then parent:GetDescendants() else parent:GetChildren()

	for _, module: Instance in possibleModules do
		if module:IsA("ModuleScript") then
			require(module)
		end
	end
end

--[=[
	@function Toast
	@within Bootstrap
	Starts up Toasty by calling dispatching `OnInit` and `OnStart` lifecycles
]=]
local function Toast()
	local unsortedSingletons = SingletonManager.GetAll()
	local singletons = Util.Table.TopologicalSort(unsortedSingletons, "Dependencies")

	local onInit = LifecycleManager.Create("OnInit", function(_, name: string, ...: any)
		for _, v in ipairs(singletons) do
			local func = v[name]
			if typeof(func) == "function" then
				func(v, ...)
			end
		end
	end)
	onInit:Dispatch()

	local onStart = LifecycleManager.Create("OnStart", function(_, name: string, ...: any)
		for _, v in ipairs(singletons) do
			local func = v[name]
			if typeof(func) == "function" then
				task.spawn(func, v, ...)
			end
		end
	end)
	onStart:Dispatch()
end

return {
	Toast = Toast,
	LoadModules = LoadModules,
}
