local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent
local Sha256 = require(Packages.Sha256)

local ObjectsFolder: Folder
local EventsFolder: Folder
local FunctionsFolder: Folder

if RunService:IsServer() then
	ObjectsFolder = Instance.new("Folder")
	ObjectsFolder.Name = "@ToastyEvents"
	ObjectsFolder.Parent = ReplicatedStorage

	EventsFolder = Instance.new("Folder")
	EventsFolder.Name = "RE"
	EventsFolder.Parent = ObjectsFolder

	FunctionsFolder = Instance.new("Folder")
	FunctionsFolder.Name = "RF"
	FunctionsFolder.Parent = ObjectsFolder
else
	ObjectsFolder = ReplicatedStorage:WaitForChild("@ToastyEvents", 10)
	assert(ObjectsFolder ~= nil, "Client could not find networking objects folder")

	EventsFolder = ObjectsFolder:WaitForChild("RE", 10) :: Folder
	assert(EventsFolder ~= nil, "Client could not find RE folder")

	FunctionsFolder = ObjectsFolder:WaitForChild("RF", 10) :: Folder
	assert(FunctionsFolder ~= nil, "Client could not find RF folder")
end

local function GetEventServer(name: string, unreliable: boolean)
	if _G.__TOASTY_OBFUSCATE__ == true then
		name = Sha256(name)
	end

	local event = EventsFolder:FindFirstChild(name)
	if event == nil then
		event = Instance.new(if unreliable then "UnreliableRemoteEvent" else "RemoteEvent")
		event.Name = name
		event.Parent = EventsFolder
	end

	return event :: RemoteEvent
end

local function GetEventClient(name: string)
	if _G.__TOASTY_OBFUSCATE__ == true then
		name = Sha256(name)
	end

	return EventsFolder:WaitForChild(name, 5) :: RemoteEvent?
end

return {
	ObjectsFolder = ObjectsFolder,
	EventsFolder = EventsFolder,
	FunctionsFolder = FunctionsFolder,

	GetEventClient = GetEventClient,
	GetEventServer = GetEventServer,
}
