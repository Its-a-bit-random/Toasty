local Shared = require(script.Parent.Parent.Shared)
local Promise = require(script.Parent.Parent.Parent.Parent.Promise)

--[=[
	@class ClientEvent
]=]
local ClientEvent = {}
ClientEvent.__index = ClientEvent

export type ClientEvent = {
	Fire: (self: ClientEvent, ...any) -> (),
	SetCallback: (
		self: ClientEvent,
		expects: { Shared.TypeCheckFunc },
		callback: (...any) -> ()
	) -> RBXScriptConnection,
	_Instance: RemoteEvent,
	_CallbackSet: boolean,
}

--[=[
	@function new
	@param instance RemoteEvent
	@return ClientEvent
	@within ClientEvent
]=]
function ClientEvent.new(instance: RemoteEvent)
	local self = setmetatable({}, ClientEvent)
	self._CallbackSet = false
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
	@method SetCallback
	@param expects {TypeCheckFunc} -- What is expected from the server
	@param callback (...any) -> ()
	@return RBXScriptConnection
	@within ClientEvent

	Sets the callback for the event.
]=]
function ClientEvent.SetCallback(
	self: ClientEvent,
	expects: { Shared.TypeCheckFunc },
	callback: (player: Player, ...any) -> ()
)
	if self._CallbackSet then
		error("Callback already set")
		return
	end
	self._CallbackSet = true
	return self._Instance.OnClientEvent:Connect(function(...: any)
		local args = { ... }

		for i, checkFunc in expects do
			local arg = args[i]
			local success, errorMessage = checkFunc(arg)

			if not success then
				warn("Failed type check: Check func returned false:", errorMessage)
				error("Unprocessed")
			end
		end

		callback(...)
	end)
end

-------------------------------------------------------------------

--[=[
	@class ClientFunction
]=]
local ClientFunction = {}
ClientFunction.__index = ClientFunction

export type ClientFunction = {
	Fire: (self: ClientFunction, expects: { Shared.TypeCheckFunc }, ...any) -> Promise.Promise,
	_Instance: RemoteFunction,
	_CallbackSet: boolean,
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
	self._CallbackSet = false

	return self :: ClientFunction
end

--[=[
	@method Fire
	@param expects {TypeCheckFunc} -- What is expected to be returned from the server
	@param ... any
	@return Promise
	@within ClientFunction

	Invokes the underlying event to the server and wraps it in a promise
	which resolves with whatever the server returns.
]=]
function ClientFunction.Fire(self: ClientFunction, expects: { Shared.TypeCheckFunc }, ...: any)
	local args = { ... }
	local promise = Promise.new(function(resolve: (...any) -> ())
		resolve(self._Instance:InvokeServer(table.unpack(args)))
	end):andThen(function(...: any): ...any
		local returns = { ... }

		for i, checkFunc in expects do
			local arg = returns[i]
			local success, errorMessage = checkFunc(arg)

			if not success then
				error("Failed type check: Check func returned false:", errorMessage)
			end
		end

		return table.unpack(returns)
	end)
	return promise
end

return {
	ClientEvent = ClientEvent.new,
	ClientFunction = ClientFunction.new,
}
