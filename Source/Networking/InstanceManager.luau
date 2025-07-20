local RunService = game:GetService("RunService")

local ObjectsFolder: Folder
local EventsFolder: Folder
local FunctionsFolder: Folder

if RunService:IsServer() then
	ObjectsFolder = Instance.new("Folder")
	ObjectsFolder.Name = "Objects"
	ObjectsFolder.Parent = script

	EventsFolder = Instance.new("Folder")
	EventsFolder.Name = "RE"
	EventsFolder.Parent = ObjectsFolder

	FunctionsFolder = Instance.new("Folder")
	FunctionsFolder.Name = "RF"
	FunctionsFolder.Parent = ObjectsFolder
else
	ObjectsFolder = script:WaitForChild("Objects", 10)
	assert(ObjectsFolder ~= nil, "Client could not find networking objects folder")

	EventsFolder = ObjectsFolder:WaitForChild("RE", 10) :: Folder
	assert(EventsFolder ~= nil, "Client could not find RE folder")

	FunctionsFolder = ObjectsFolder:WaitForChild("RF", 10) :: Folder
	assert(FunctionsFolder ~= nil, "Client could not find RF folder")
end

local function GetEventServer(name: string, unreliable: boolean)
	local event = EventsFolder:FindFirstChild(name)
	if event == nil then
		event = Instance.new(if unreliable then "UnreliableRemoteEvent" else "RemoteEvent")
		event.Name = name
		event.Parent = EventsFolder
	end

	return event :: RemoteEvent
end

local function GetEventClient(name: string)
	return EventsFolder:WaitForChild(name, 5) :: RemoteEvent?
end

return {
	ObjectsFolder = ObjectsFolder,
	EventsFolder = EventsFolder,
	FunctionsFolder = FunctionsFolder,

	GetEventClient = GetEventClient,
	GetEventServer = GetEventServer,
}
