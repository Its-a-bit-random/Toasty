local Core = script.Parent
local Types = require(Core.Types)
local Flags = require(Core.Parent.Flags)

local SingletonManagerModule = require(Core.SingletonManager)
local GetAll = SingletonManagerModule.GetAll

local function GetSingletonsWhichImplement(lifecycle: string)
	local singletons = GetAll()
	local singletonsWhichImplement = {}

	for _, v in singletons do
		if table.find(v.Implements, lifecycle) then
			local foundFunc = v[lifecycle] :: (self: Types.Singleton, ...any) -> ()?
			assert(foundFunc ~= nil, `Singleton implements {lifecycle} but has no function`)
			table.insert(singletonsWhichImplement, v)
		end
	end

	return singletonsWhichImplement
end

--[=[
	@class Lifecycle
	A lifecycle event
]=]
local Lifecycle = {}
Lifecycle.__index = Lifecycle

--[=[
	@param name string -- Name of the lifecycle event
	@param handler LifecycleHandler
	@return Lifecycle
	Create a new lifecycle event
]=]
function Lifecycle.new(name: string, handler: Types.LifecycleHandler)
	local self = setmetatable({}, Lifecycle)

	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print("[TOASTY]", `Creating new lifecycle with name {name}`)
	end

	--[=[
		@readonly
		@prop Name string
		@within Lifecycle

		Name of the lifecycle
	]=]
	self.Name = name

	--[=[
		@readonly
		@private
		@prop _OnDispatch LifecycleHandler
		@within Lifecycle

		Handler which is in charge of calling the functions on singletons
	]=]
	self._OnDispatch = handler

	return self :: Types.Lifecycle
end

--[=[
	@method Dispatch
	@param ... any -- Args to pass to all singletons which implement this lifecycle event
	@within Lifecycle

	Dispatch the lifecycle event with some arguments which are passed all singletons which implement
	this lifecycle event.
]=]
function Lifecycle.Dispatch(self: Types.Lifecycle, ...: any)
	local singletons = GetSingletonsWhichImplement(self.Name)

	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print("[TOASTY]", `Dispatching lifecycle with name {self.Name} to {#singletons} singletons`)
	end

	self._OnDispatch(singletons, self.Name, ...)
end

return {
	new = Lifecycle.new,
}
