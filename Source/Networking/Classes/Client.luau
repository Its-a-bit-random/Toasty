local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)

local ClientEvent = {}
ClientEvent.__index = ClientEvent

export type ClientEvent = {
	Fire: (self: ClientEvent, ...any) -> (),
	AddCallback: (self: ClientEvent, callback: (...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteEvent,
}

function ClientEvent.new(instance: RemoteEvent)
	local self = setmetatable({}, ClientEvent)
	self._Instance = instance
	return self :: ClientEvent
end

function ClientEvent.Fire(self: ClientEvent, ...: any)
	self._Instance:FireServer(...)
end

function ClientEvent.AddCallback(self: ClientEvent, callback: (...any) -> ())
	self._Instance.OnClientEvent:Connect(callback)
end

-------------------------------------------------------------------

local ClientFunction = {}
ClientFunction.__index = ClientFunction

export type ClientFunction = {
	Fire: (self: ClientFunction, ...any) -> Promise.Promise,
	SetCallback: (self: ClientEvent, callback: (...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteFunction,
}

function ClientFunction.new(instance: RemoteFunction)
	local self = setmetatable({}, ClientFunction)
	self._Instance = instance
	return self :: ClientFunction
end

function ClientFunction.Fire(self: ClientFunction, ...: any)
	local args = { ... }
	local promise = Promise.new(function(resolve: (...any) -> ())
		resolve(self._Instance:InvokeServer(table.unpack(args)))
	end)
	return promise
end

function ClientFunction.SetCallback(self: ClientFunction, callback: (...any) -> ())
	self._Instance.OnClientInvoke = callback
end

return {
	ClientEvent = ClientEvent.new,
	ClientFunction = ClientFunction.new,
}
