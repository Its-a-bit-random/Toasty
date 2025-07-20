local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent
local Sha256 = require(Packages.Sha256)

local eventsFolder: Folder
local functionsFolder: Folder

if RunService:IsServer() then
	eventsFolder = Instance.new("Folder")
	eventsFolder.Name = "ToastyNetworking@Events"
	eventsFolder.Parent = ReplicatedStorage

	functionsFolder = Instance.new("Folder")
	functionsFolder.Name = "ToastyNetworking@Functions"
	functionsFolder.Parent = ReplicatedStorage
else
	eventsFolder = ReplicatedStorage:WaitForChild("ToastyNetworking@Events", 5)
	functionsFolder = ReplicatedStorage:WaitForChild("ToastyNetworking@Functions", 5)
	assert(eventsFolder ~= nil or functionsFolder ~= nil, `Client could not find event or functions folder`)
end

local function GetEventServer(name: string, unreliable: boolean)
	if _G.__TOASTY_OBFUSCATE__ == true then
		name = Sha256(name)
	end

	local event = eventsFolder:FindFirstChild(name)
	if event == nil then
		local className = if unreliable then "UnreliableRemoteEvent" else "RemoteEvent"
		event = Instance.new(className)
		event.Name = name
		event.Parent = eventsFolder
	end

	return event :: RemoteEvent
end

local function GetFunctionServer(name: string, unreliable: boolean)
	if _G.__TOASTY_OBFUSCATE__ == true then
		name = Sha256(name)
	end

	local event = functionsFolder:FindFirstChild(name)
	if event == nil then
		local className = if unreliable then "UnreliableRemoteFunction" else "RemoteFunction"
		event = Instance.new(className)
		event.Name = name
		event.Parent = functionsFolder
	end

	return event :: RemoteFunction
end

local function GetEventClient(name: string)
	local event = eventsFolder:WaitForChild(name, 5)
	assert(event ~= nil, `Could not find event {name}`)
	return event :: RemoteEvent
end

local function GetFunctionClient(name: string)
	local event = functionsFolder:WaitForChild(name, 5)
	assert(event ~= nil, `Could not find function {name}`)
	return event :: RemoteFunction
end

return {
	GetEventServer = GetEventServer,
	GetEventClient = GetEventClient,

	GetFunctionServer = GetFunctionServer,
	GetFunctionClient = GetFunctionClient,
}
