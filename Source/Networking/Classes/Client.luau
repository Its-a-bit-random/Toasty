local Shared = require(script.Parent.Parent.Shared)
local Promise = require(script.Parent.Parent.Parent.Parent.Promise)
local Connection = require(script.Parent.Connection)
local Types = require(script.Parent.Parent.Parent.Core.Types)

--[=[
	@class ClientEvent
]=]
local ClientEvent = {}
ClientEvent.__index = ClientEvent
export type ClientEvent = {
	Fire: (self: ClientEvent, ...any) -> (),
	AddMiddleware: (self: ClientEvent, fn: Types.MiddlewareFn) -> (),
	SetCallback: (
		self: ClientEvent,
		expects: { Shared.TypeCheckFunc },
		callback: (...any) -> ()
	) -> Connection.Connection,
	Predict: (self: ClientEvent, ...any) -> (),
	_Instance: RemoteEvent,
	_CallbackSet: boolean,
	_Callback: (...any) -> ()?,
	_Middleware: { Types.MiddlewareFn },
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
	@method AddMiddleware
	@param fn MiddlewareFn
	@within ClientEvent

	Add a middleware function to run after the event is fired
]=]
function ClientEvent.AddMiddleware(self: ClientEvent, fn: Types.MiddlewareFn)
	table.insert(self._Middleware, fn)
end

--[=[
	@method SetCallback
	@param expects {TypeCheckFunc} -- What is expected from the server
	@param callback (...any) -> ()
	@return Connection
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
	self._Callback = function(...: any)
		local args = { ... }

		-- Types
		for i, checkFunc in expects do
			local arg = args[i]
			local success, errorMessage = checkFunc(arg)

			if not success then
				warn("Failed type check: Check func returned false:", errorMessage)
				error("Unprocessed")
			end
		end

		-- Middleware
		local result = Shared.RunMiddleware(self._Middleware, args)
		if result == Shared.MiddlewareDenyMarker then
			return
		end

		-- Actual callback
		callback(table.unpack(args))
	end

	local robloxConn = self._Instance.OnClientEvent:Connect(function(...)
		self:Predict(...)
	end)

	local wrapped = Connection.Connection(robloxConn)

	wrapped._Disconnected:Connect(function()
		self._CallbackSet = false
		self._Callback = nil
	end)

	return wrapped
end

--[=[
	@method Predict
	@param ... any
	@within ClientEvent

	Fires an event from the client to client, this would be the same as firing a `BindableEvent`
]=]
function ClientEvent.Predict(self: ClientEvent, ...: any)
	if self._Callback then
		self._Callback(...)
	else
		warn("Callback not set")
	end
end

-------------------------------------------------------------------

--[=[
	@class ClientFunction
]=]
local ClientFunction = {}
ClientFunction.__index = ClientFunction

export type ClientFunction = {
	Fire: (self: ClientFunction, expects: { Shared.TypeCheckFunc }, ...any) -> Promise.Promise,
	_Instance: RemoteEvent,
}

--[=[
	@function new
	@param instance RemoteEvent
	@return ClientFunction
	@within ClientFunction
]=]
function ClientFunction.new(instance: RemoteEvent)
	local self = setmetatable({}, ClientFunction)

	--[=[
		@prop _Instance RemoteEvent
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
	return Promise.new(function(resolve: (...any) -> (), _, onCancel)
		local requestId = Shared.GenerateRequestID()
		self._Instance:FireServer(requestId, table.unpack(args))

		local conn
		conn = self._Instance.OnClientEvent:Connect(function(id: string, ...)
			if id == requestId then
				conn:Disconnect()
				resolve(...)
			end
		end)

		onCancel(function()
			conn:Disconnect()
		end)
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
end

return {
	ClientEvent = ClientEvent.new,
	ClientFunction = ClientFunction.new,
}
