local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local PacketSender = {}
PacketSender.__index = PacketSender

type PacketSenderClass = {
	_Event: RemoteEvent,
	WrapEvent: (event: RemoteEvent) -> PacketSenderClass,
	Fire: (self: PacketSenderClass, player: Player, ...any) -> nil,
	Broadcast: (self: PacketSenderClass, ...any) -> nil,
}

function PacketSender._new(event: RemoteEvent)
	local self = setmetatable({}, PacketSender)
	self._Event = event
	return self :: PacketSenderClass
end

function PacketSender.WrapEvent(event: RemoteEvent)
	return PacketSender._new(event)
end

function PacketSender.Fire(self: PacketSenderClass, player: Player, ...: any)
	local args = { ... }
	if RunService:IsServer() then
		self._Event:FireClient(player, table.unpack(args))
	else
		self._Event:FireServer(table.unpack(args))
	end
end

function PacketSender.Broadcast(self: PacketSenderClass, ...: any)
	local args = { ... }
	for _, player in Players:GetPlayers() do
		self:Fire(player, table.unpack(args))
	end
end

return {
	PacketSender = PacketSender,
}
