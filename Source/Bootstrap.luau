local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Toasty = script.Parent
local Types = require(ReplicatedStorage.Packages.Toasty.Core.Types)
local Flags = require(script.Parent.Flags)
local Util = require(Toasty.Util)
local SingletonManager = require(Toasty.Core.SingletonManager)
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
	@function LoadSingletonModules
	@within Bootstrap
	@param parent Instance
	@param recursive boolean

	Calls require on all [ModuleScript] instances parented under the passed parant. It also
	creates singletons for every module meaning you can use this to avoid having to write
	`Toasty.Service()`/`Toasty.Controller()` in every module.
]=]
local function LoadSingletonModules(parent: Instance, recursive: boolean)
	local possibleModules = if recursive then parent:GetDescendants() else parent:GetChildren()

	for _, module: Instance in possibleModules do
		if module:IsA("ModuleScript") then
			local singleton = require(module)
			SingletonManager.Create(singleton)
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

	local loadOrderedSingletons = {}
	for _, singleton in unsortedSingletons do
		local tbl = loadOrderedSingletons[singleton.LoadOrder] or {}
		table.insert(tbl, singleton)
		loadOrderedSingletons[singleton.LoadOrder] = tbl
	end

	local sortedSingletons = {}
	for loadOrder, singletons in loadOrderedSingletons do
		local sorted = Util.Table.TopologicalSort(singletons, "Dependencies")
		sortedSingletons[loadOrder] = sorted
	end

	local onInit = LifecycleManager.Create("OnInit", function(_, name: string, ...: any)
		for loadOrder, singletons in ipairs(sortedSingletons) do
			if Flags.IsEnabled(Flags.Flags.Verbose) then
				print("[TOASTY]", `LOAD ORDER = {loadOrder}`)
			end

			for i, v: Types.Singleton in ipairs(singletons) do
				if v["__TOASTY_INIT__"] == true then
					continue
				end

				local func = v[name]
				if typeof(func) == "function" then
					func(v, ...)
					v["__TOASTY_INIT__"] = true
					if Flags.IsEnabled(Flags.Flags.Verbose) then
						print("[TOASTY]", `{i} / {#singletons}`)
					end
				end
			end
		end
	end)
	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print(string.rep("=", 50))
		print("[TOASTY]", "INITIALIZING SINGLETONS")
	end
	onInit:Dispatch()
	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print(string.rep("=", 50))
	end

	local onStart = LifecycleManager.Create("OnStart", function(_, name: string, ...: any)
		for loadOrder, singletons in ipairs(sortedSingletons) do
			if Flags.IsEnabled(Flags.Flags.Verbose) then
				print("[TOASTY]", `LOAD ORDER = {loadOrder}`)
			end

			for i, v in ipairs(singletons) do
				if v["__TOASTY_START__"] == true then
					continue
				end
				local func = v[name]
				if typeof(func) == "function" then
					v["__TOASTY_START__"] = true
					func(v, ...)
					if Flags.IsEnabled(Flags.Flags.Verbose) then
						print("[TOASTY]", `{i} / {#singletons}`)
					end
				end
			end
		end
	end)
	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print(string.rep("=", 50))
		print("[TOASTY]", "STARTING SINGLETONS")
	end
	onStart:Dispatch()
	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print(string.rep("=", 50))
	end
end

return {
	Toast = Toast,
	LoadModules = LoadModules,
	LoadSingletonModules = LoadSingletonModules,
}
