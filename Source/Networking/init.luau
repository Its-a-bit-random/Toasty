local RunService = game:GetService("RunService")

local PacketSender = require(script.PacketSender).PacketSender
local PacketReciever = require(script.PacketReciever).PacketReciever

local EventFolder = if RunService:IsServer()
	then Instance.new("Folder")
	else script:WaitForChild("Events", 10) :: Folder

if RunService:IsServer() then
	EventFolder.Parent = script
	EventFolder.Name = "Events"
end

local function ServerToClientSender(name: string)
	local foundEvent = EventFolder:FindFirstChild(name) :: RemoteEvent

	if foundEvent == nil then
		foundEvent = Instance.new("RemoteEvent")
		foundEvent.Name = name
		foundEvent.Parent = EventFolder
	end

	return PacketSender.WrapEvent(foundEvent)
end

local function ServerToClientReciever(name: string)
	local foundEvent = EventFolder:WaitForChild(name, 10) :: RemoteEvent
	assert(foundEvent ~= nil, `Event {name} not found`)

	return PacketReciever.WrapEvent(foundEvent)
end

return {
	ServerToClientSender = ServerToClientSender,
	ServerToClientReciever = ServerToClientReciever,
}
