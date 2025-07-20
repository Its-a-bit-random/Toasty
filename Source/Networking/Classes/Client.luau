local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)

--[=[
	@class ClientEvent
]=]
local ClientEvent = {}
ClientEvent.__index = ClientEvent

export type ClientEvent = {
	Fire: (self: ClientEvent, ...any) -> (),
	AddCallback: (self: ClientEvent, callback: (...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteEvent,
}

--[=[
	@function new
	@param instance RemoteEvent
	@return ClientEvent
	@within ClientEvent
]=]
function ClientEvent.new(instance: RemoteEvent)
	local self = setmetatable({}, ClientEvent)
	self._Instance = instance
	return self :: ClientEvent
end

--[=[
	@method Fire
	@param ... any
	@within ClientEvent

	Fires the underlying event to the server
]=]
function ClientEvent.Fire(self: ClientEvent, ...: any)
	self._Instance:FireServer(...)
end

--[=[
	@method AddCallback
	@param callback (...any) -> ()
	@return RBXScriptConnection
	@within ClientEvent

	Adds a callback to the event. An event can have as many callbacks as you want as
	well as returing the connection.
]=]
function ClientEvent.AddCallback(self: ClientEvent, callback: (...any) -> ())
	return self._Instance.OnClientEvent:Connect(callback)
end

-------------------------------------------------------------------

--[=[
	@class ClientFunction
]=]
local ClientFunction = {}
ClientFunction.__index = ClientFunction

export type ClientFunction = {
	Fire: (self: ClientFunction, ...any) -> Promise.Promise,
	SetCallback: (self: ClientFunction, callback: (...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteFunction,
}

--[=[
	@function new
	@param instance RemoteFunction
	@return ClientFunction
	@within ClientFunction
]=]
function ClientFunction.new(instance: RemoteFunction)
	local self = setmetatable({}, ClientFunction)

	--[=[
		@prop _Instance RemoteFunction
		@private
		@readonly
		@within ClientFunction
	]=]
	self._Instance = instance

	return self :: ClientFunction
end

--[=[
	@method Fire
	@param ... any
	@return Promise
	@within ClientFunction

	Invokes the underlying event to the server and wraps it in a promise
	which resolves with whatever the server returns.
]=]
function ClientFunction.Fire(self: ClientFunction, ...: any)
	local args = { ... }
	local promise = Promise.new(function(resolve: (...any) -> ())
		resolve(self._Instance:InvokeServer(table.unpack(args)))
	end)
	return promise
end

--[=[
	@method SetCallback
	@param callback (...any) -> ()
	@within ClientFunction

	**sets** the callback to the function, a function can only have **one** callback.
]=]
function ClientFunction.SetCallback(self: ClientFunction, callback: (...any) -> ())
	self._Instance.OnClientInvoke = callback
end

return {
	ClientEvent = ClientEvent.new,
	ClientFunction = ClientFunction.new,
}
