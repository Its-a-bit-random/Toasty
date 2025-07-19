local RunService = game:GetService("RunService")

local PacketReciever = {}
PacketReciever.__index = PacketReciever

type PacketRecieverClass = {
	_Event: RemoteEvent,
	WrapEvent: (event: RemoteEvent) -> PacketRecieverClass,
	Connect: (self: PacketRecieverClass, callback: (...any) -> nil) -> nil,
}

function PacketReciever._new(event: RemoteEvent)
	local self = setmetatable({}, PacketReciever)
	self._Event = event
	return self :: PacketRecieverClass
end

function PacketReciever.WrapEvent(event: RemoteEvent)
	return PacketReciever._new(event)
end

function PacketReciever.Connect(self: PacketRecieverClass, callback: (...any) -> nil)
	if RunService:IsServer() then
		self._Event.OnServerEvent:Connect(callback)
	else
		self._Event.OnClientEvent:Connect(callback)
	end
end

return {
	PacketReciever = PacketReciever,
}
