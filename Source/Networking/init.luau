local RunService = game:GetService("RunService")

local Shared = require(script.Shared)
local InstanceManager = require(script.InstanceManager)
local Util = require(script.Parent.Util)

local ServerClasses = require(script.Classes.Server)
local ClientClasses = require(script.Classes.Client)

--[=[
	@class Networking
	@external Promise https://eryn.io/roblox-lua-promise/api/Promise
]=]

--[=[
	@interface EventReturn
	.Client ClientEvent
	.Server ServerEvent
	@within Networking
]=]

--[=[
	@interface FunctionReturn
	.Client ClientFunction
	.Server ServerFunction
	@within Networking
]=]

--[=[
	@function Event
	@return EventReturn
	@within Networking

	Create an event which allows for one-way communication between the server and
	client(s).
]=]
local function Event()
	local tbl = {
		Instance = Shared.EventMarker,
	} :: any
	return tbl :: { Client: ClientClasses.ClientEvent, Server: ServerClasses.ServerEvent }
end

--[=[
	@function UnreliableEvent
	@return EventReturn
	@within Networking

	Create an event which allows for one-way communication between the server and
	client(s).
]=]
local function UnreliableEvent()
	local tbl = {
		Instance = Shared.UnreliableEventMarker,
	} :: any
	return tbl :: { Client: ClientClasses.ClientEvent, Server: ServerClasses.ServerEvent }
end

--[=[
	@function Function
	@return FunctionReturn
	@within Networking

	Create an event which allows for two-way communication between the server and
	client(s).
]=]
local function Function()
	local tbl = {
		Instance = Shared.FunctionMarker,
	} :: any
	return tbl :: { Client: ClientClasses.ClientFunction, Server: ServerClasses.ServerFunction }
end

--[=[
	@function UnreliableFunction
	@return FunctionReturn
	@within Networking

	Create an event which allows for two-way communication between the server and
	client(s).
]=]
local function UnreliableFunction()
	local tbl = {
		Instance = Shared.UnreliableFunctionMarker,
	} :: any
	return tbl :: { Client: ClientClasses.ClientFunction, Server: ServerClasses.ServerFunction }
end

--[=[
	@private
	@function ParseEvents
	@param key string
	@param events {EventTable} | EventTable
	@within Networking
]=]
local function ParseEvents(key: string, events: { { Shared.EventTable } | Shared.EventTable })
	local tableType = Util.Table.CheckTableType(events)
	if tableType == Util.Table.CheckTableTypeResult.NotTable then
		warn(`Skipping {key} in events because its not a table`)
		return
	end

	if tableType == Util.Table.CheckTableTypeResult.SingleTable then
		local retypedEvents = events :: Shared.EventTable
		if retypedEvents.Instance == Shared.EventMarker then
			if RunService:IsServer() then
				local inst = InstanceManager.GetEventServer(key, false)
				retypedEvents.Server = ServerClasses.ServerEvent(inst)
			else
				local inst = InstanceManager.GetEventServer(key, false)
				retypedEvents.Client = ClientClasses.ClientEvent(inst)
			end
		elseif retypedEvents.Instance == Shared.UnreliableEventMarker then
			if RunService:IsServer() then
				local inst = InstanceManager.GetEventServer(key, true)
				retypedEvents.Server = ServerClasses.ServerEvent(inst)
			else
				local inst = InstanceManager.GetEventClient(key)
				retypedEvents.Client = ClientClasses.ClientEvent(inst)
			end
		elseif retypedEvents.Instance == Shared.FunctionMarker then
			if RunService:IsServer() then
				local inst = InstanceManager.GetFunctionServer(key, false)
				retypedEvents.Server = ServerClasses.ServerFunction(inst)
			else
				local inst = InstanceManager.GetFunctionClient(key)
				retypedEvents.Client = ClientClasses.ClientFunction(inst)
			end
		elseif retypedEvents.Instance == Shared.UnreliableFunctionMarker then
			if RunService:IsServer() then
				local inst = InstanceManager.GetFunctionServer(key, true)
				retypedEvents.Server = ServerClasses.ServerFunction(inst)
			else
				local inst = InstanceManager.GetFunctionClient(key)
				retypedEvents.Client = ClientClasses.ClientFunction(inst)
			end
		end
		return
	end

	if tableType == Util.Table.CheckTableTypeResult.TableOfTables then
		for childKey, childEvents in events do
			local newKey = key .. "/" .. childKey
			if key == "" then
				newKey = childKey
			end
			ParseEvents(newKey, childEvents)
		end
	end
end

--[=[
	@function Setup
	@param module ModuleScript
	@within Networking

	Takes in a module script that contains a table of events and functions and conerts
	it into objects.
]=]
local function Setup(module: ModuleScript)
	ParseEvents("", require(module))
end

--[=[
	@function SetupFromModule
	@param module ModuleScript
	@deprecated v1.0.0 -- Use `.Setup()` instead
	@within Networking

	Takes in a module script that contains a table of events and functions and conerts
	it into objects.
]=]
local function SetupFromModule(_module: ModuleScript)
	warn(".SetupFromModule() is deprecated; please use .Setup() instead")
	Setup(_module)
end

return {
	Event = Event,
	Function = Function,
	UnreliableEvent = UnreliableEvent,
	UnreliableFunction = UnreliableFunction,

	SetupFromModule = SetupFromModule,
	Setup = Setup,

	Arg = require(script.Arg),
}
