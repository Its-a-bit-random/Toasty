local Players = game:GetService("Players")

local ServerEvent = {}
ServerEvent.__index = ServerEvent

export type ServerEvent = {
	Fire: (self: ServerEvent, player: Player, ...any) -> (),
	FirePlayers: (self: ServerEvent, players: { Player }, ...any) -> (),
	Broadcast: (self: ServerEvent, ...any) -> (),
	AddCallback: (self: ServerEvent, callback: (player: Player, ...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteEvent,
}

function ServerEvent.new(instance: RemoteEvent)
	local self = setmetatable({}, ServerEvent)
	self._Instance = instance
	return self :: ServerEvent
end

function ServerEvent.Fire(self: ServerEvent, player: Player, ...: any)
	self._Instance:FireClient(player, ...)
end

function ServerEvent.FirePlayers(self: ServerEvent, players: { Player }, ...: any)
	for _, player in players do
		self:Fire(player, ...)
	end
end

function ServerEvent.Broadcast(self: ServerEvent, ...: any)
	self:FirePlayers(Players:GetPlayers(), ...)
end

function ServerEvent.AddCallback(self: ServerEvent, callback: (player: Player, ...any) -> ())
	self._Instance.OnServerEvent:Connect(callback)
end

-------------------------------------------------------------------

local ServerFunction = {}
ServerFunction.__index = ServerFunction

export type ServerFunction = {
	Fire: (self: ServerFunction, player: Player, ...any) -> (),
	FirePlayers: (self: ServerFunction, players: { Player }, ...any) -> (),
	Broadcast: (self: ServerFunction, ...any) -> (),
	SetCallback: (self: ServerEvent, callback: (player: Player, ...any) -> ()) -> RBXScriptConnection,
	_Instance: RemoteFunction,
}

function ServerFunction.new(instance: RemoteFunction)
	local self = setmetatable({}, ServerFunction)
	self._Instance = instance
	return self :: ServerFunction
end

function ServerFunction.Fire(self: ServerFunction, player: Player, ...: any)
	local args = { ... }
	self._Instance:InvokeClient(player, table.unpack(args))
end

function ServerFunction.FirePlayers(self: ServerFunction, players: { Player }, ...: any)
	for _, player in players do
		self:Fire(player, ...)
	end
end

function ServerFunction.Broadcast(self: ServerFunction, ...: any)
	self:FirePlayers(Players:GetPlayers(), ...)
end

function ServerFunction.SetCallback(self: ServerFunction, callback: (player: Player, ...any) -> ())
	self._Instance.OnServerInvoke = callback
end

return {
	ServerEvent = ServerEvent.new,
	ServerFunction = ServerFunction.new,
}
