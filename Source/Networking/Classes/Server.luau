local Players = game:GetService("Players")

local Shared = require(script.Parent.Parent.Shared)

--[=[
	@class ServerEvent
]=]
local ServerEvent = {}
ServerEvent.__index = ServerEvent

export type ServerEvent = {
	Fire: (self: ServerEvent, player: Player, ...any) -> (),
	FirePlayers: (self: ServerEvent, players: { Player }, ...any) -> (),
	Broadcast: (self: ServerEvent, ...any) -> (),
	SetCallback: (
		self: ServerEvent,
		expects: { Shared.TypeCheckFunc },
		callback: (player: Player, ...any) -> ()
	) -> RBXScriptConnection,
	Predict: (self: ServerEvent, player: Player, ...any) -> (),
	_Instance: RemoteEvent,
	_CallbackSet: boolean,
	_Callback: (...any) -> (),
}

--[=[
	@function new
	@param instance RemoteEvent
	@return ServerEvent
	@within ServerEvent
]=]
function ServerEvent.new(instance: RemoteEvent)
	local self = setmetatable({}, ServerEvent)
	self._CallbackSet = false
	self._Instance = instance
	return self :: ServerEvent
end

--[=[
	@method Fire
	@param player Player
	@param ... any
	@within ServerEvent
]=]
function ServerEvent.Fire(self: ServerEvent, player: Player, ...: any)
	self._Instance:FireClient(player, ...)
end

--[=[
	@method FirePlayers
	@param players {Player}
	@param ... any
	@within ServerEvent
]=]
function ServerEvent.FirePlayers(self: ServerEvent, players: { Player }, ...: any)
	for _, player in players do
		self:Fire(player, ...)
	end
end

--[=[
	@method Broadcast
	@param ... any
	@within ServerEvent
]=]
function ServerEvent.Broadcast(self: ServerEvent, ...: any)
	self:FirePlayers(Players:GetPlayers(), ...)
end

--[=[
	@method SetCallback
	@param expects {TypeCheckFunc} -- What is expected from the client
	@param callback (player: Player, ...any) -> ()
	@within ServerEvent

	Sets the callback for the event.
]=]
function ServerEvent.SetCallback(
	self: ServerEvent,
	expects: { Shared.TypeCheckFunc },
	callback: (player: Player, ...any) -> ()
)
	if self._CallbackSet then
		error("Callback already set")
		return
	end
	self._CallbackSet = true
	self._Callback = function(player: Player, ...: any)
		local args = { ... }

		for i, checkFunc in expects do
			local arg = args[i]
			local success, errorMessage = checkFunc(arg)

			if not success then
				warn("Failed type check: Check func returned false:", errorMessage)
				error("Unprocessed")
			end
		end

		callback(player, ...)
	end

	self._Instance.OnServerEvent:Connect(function(...: any)
		self:Predict(...)
	end)
end

--[=[
	@method Predict
	@param player Player
	@param ... any
	@within ServerEvent

	Fire an event from server to the server as a player
]=]
function ServerEvent.Predict(self: ServerEvent, player: Player, ...: any)
	if self._Callback then
		self._Callback(player, ...)
	else
		warn("No callback")
	end
end

-------------------------------------------------------------------

--[=[
	@class ServerFunction
]=]
local ServerFunction = {}
ServerFunction.__index = ServerFunction

export type ServerFunction = {
	Fire: (self: ServerFunction, player: Player, ...any) -> (),
	FirePlayers: (self: ServerFunction, players: { Player }, ...any) -> (),
	Broadcast: (self: ServerFunction, ...any) -> (),
	Predict: (self: ServerFunction, player: Player, ...any) -> (),
	SetCallback: (
		self: ServerEvent,
		expects: { Shared.TypeCheckFunc },
		callback: (player: Player, ...any) -> ()
	) -> RBXScriptConnection,
	_Instance: RemoteEvent,
	_CallbackSet: boolean,
	_Callback: (...any) -> (),
}

--[=[
	@function new
	@param instance RemoteEvent
	@return ServerFunction
	@within ServerFunction
]=]
function ServerFunction.new(instance: RemoteEvent)
	local self = setmetatable({}, ServerFunction)
	self._Instance = instance
	self._CallbackSet = false
	return self :: ServerFunction
end

--[=[
	@method SetCallback
	@param expects {TypeCheckFunc} -- What is expected from the client
	@param callback (player: Player, ...any) -> ()
	@within ServerFunction

	Sets the callback for the event.
]=]
function ServerFunction.SetCallback(
	self: ServerFunction,
	expects: { Shared.TypeCheckFunc },
	callback: (player: Player, ...any) -> ()
)
	if self._CallbackSet then
		error("Callback already set")
		return
	end

	self._CallbackSet = true
	self._Callback = function(player: Player, ...)
		local args = { ... }

		for i, checkFunc in expects do
			local arg = args[i]
			local success, errorMessage = checkFunc(arg)

			if not success then
				error("Failed type check: Check func returned false:", errorMessage)
			end
		end

		return callback(player, ...)
	end

	return self._Instance.OnServerEvent:Connect(function(player, id, ...)
		self._Instance:FireClient(player, id, self._Callback(player, ...))
	end)
end

--[=[
	@method Predict
	@param Player player
	@param ... any
	@within ServerFunction

	Fire a function from the server to the server as a player.
]=]
function ServerFunction.Predict(self: ServerFunction, player: Player, ...: any)
	return self._Callback(player, ...)
end

return {
	ServerEvent = ServerEvent.new,
	ServerFunction = ServerFunction.new,
}
