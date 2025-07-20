local Players = game:GetService("Players")

--[=[
	@class ServerEvent
]=]
local ServerEvent = {}
ServerEvent.__index = ServerEvent

export type ServerEvent = {
	Fire: (self: ServerEvent, player: Player, ...any) -> (),
	FirePlayers: (self: ServerEvent, players: { Player }, ...any) -> (),
	Broadcast: (self: ServerEvent, ...any) -> (),
	AddCallback: (self: ServerEvent, callback: (player: Player, ...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteEvent,
}

--[=[
	@function new
	@param instance RemoteEvent
	@return ServerEvent
	@within ServerEvent
]=]
function ServerEvent.new(instance: RemoteEvent)
	local self = setmetatable({}, ServerEvent)
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
	@method AddCallback
	@param callback (player: Player, ...any) -> ()
	@within ServerEvent
]=]
function ServerEvent.AddCallback(self: ServerEvent, callback: (player: Player, ...any) -> ())
	self._Instance.OnServerEvent:Connect(callback)
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
	SetCallback: (self: ServerEvent, callback: (player: Player, ...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteFunction,
}

--[=[
	@function new
	@param instance RemoteFunction
	@return ServerFunction
	@within ServerFunction
]=]
function ServerFunction.new(instance: RemoteFunction)
	local self = setmetatable({}, ServerFunction)
	self._Instance = instance
	return self :: ServerFunction
end

--[=[
	@method SetCallback
	@param callback (player: Player, ...any) -> ()
	@within ServerFunction

	**sets** the callback for the function, a function can only have **one** callback.
]=]
function ServerFunction.SetCallback(self: ServerFunction, callback: (player: Player, ...any) -> ())
	self._Instance.OnServerInvoke = callback
end

return {
	ServerEvent = ServerEvent.new,
	ServerFunction = ServerFunction.new,
}
