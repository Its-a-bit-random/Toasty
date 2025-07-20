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
	@function CreateEvent
	@param inputs {TypeCheckFunc}
	@param outputs {TypeCheckFunc}
	@return EventReturn
	@within Networking

	Create an event with given inputs and outputs that will be automatically type
	checked by Toasty.
]=]
local function CreateEvent(inputs: { Shared.TypeCheckFunc }, outputs: { Shared.TypeCheckFunc })
	local tbl = {
		Instance = Shared.EventMarker,
		Inputs = inputs,
		Outputs = outputs,
	} :: any
	return tbl :: { Client: ClientClasses.ClientEvent, Server: ServerClasses.ServerEvent }
end

--[=[
	@function CreateFunction
	@param inputs {TypeCheckFunc}
	@param outputs {TypeCheckFunc}
	@return FunctionReturn
	@within Networking

	Create a function with given inputs and outputs that will be automatically type
	checked by Toasty.
]=]
local function CreateFunction(inputs: { Shared.TypeCheckFunc }, outputs: { Shared.TypeCheckFunc })
	local tbl = {
		Instance = Shared.FunctionMarker,
		Inputs = inputs,
		Outputs = outputs,
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
		elseif retypedEvents.Instance == Shared.FunctionMarker then
			if RunService:IsServer() then
				local inst = InstanceManager.GetFunctionServer(key, false)
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
			ParseEvents(key .. "/" .. childKey, childEvents)
		end
	end
end

--[=[
	@function SetupFromModule
	@param module ModuleScript
	@within Networking

	Takes in a module script that contains a table of events and functions and conerts
	it into objects.

	:::warning
	This is temporary and the need for this will be removed eventually.
	:::
]=]
local function SetupFromModule(module: ModuleScript)
	local table = require(module) :: Shared.NetworkingTable
	ParseEvents("E", table.Events)
	ParseEvents("F", table.Functions)
end

return {
	CreateEvent = CreateEvent,
	CreateFunction = CreateFunction,

	SetupFromModule = SetupFromModule,
}
