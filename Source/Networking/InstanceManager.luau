local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Packages = script.Parent.Parent.Parent
local Sha256 = require(Packages.Sha256)

local RemotesFolder: Folder

if RunService:IsServer() then
	RemotesFolder = Instance.new("Folder")
	RemotesFolder.Name = "Remotes"
	RemotesFolder.Parent = ReplicatedStorage
else
	RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
	assert(RemotesFolder ~= nil, "Client could not find remotes folder")
end

local function GetFromPath(path: string, root: Instance, className: string)
	local splitPath = path:split("/")
	local instanceName = splitPath[#splitPath]
	
	for i = 1, #splitPath - 1, 1 do
		local child = splitPath[i]
		local childInstance = root:FindFirstChild(child)
		if childInstance == nil then
			childInstance = Instance.new("Folder")
			childInstance.Name = child
			childInstance.Parent = root
		end

		root = childInstance
	end

	local foundInstance = root:FindFirstChild(instanceName)

	if foundInstance then
		return foundInstance, false
	end

	local realInstance = Instance.new(className)
	realInstance.Name = instanceName
	realInstance.Parent = root
	return realInstance, true
end

--[=[
	@class InstanceManager
]=]

--[=[
	@function GetEventServer
	@param name string
	@param unreliable boolean
	@return RemoteEvent
	@within InstanceManager
]=]
local function GetEventServer(name: string, unreliable: boolean)
	if _G.__TOASTY_OBFUSCATE__ == true then
		name = Sha256(name)
	end

	local className = if unreliable then "UnreliableRemoteEvent" else "RemoteEvent"
	local event = GetFromPath(name, RemotesFolder, className)
	if event == nil then
		event = Instance.new(className)
		event.Name = name
		event.Parent = RemotesFolder
	end

	return event :: RemoteEvent
end

--[=[
	@function GetFunctionServer
	@param name string
	@param unreliable boolean
	@return RemoteFunction
	@within InstanceManager
]=]
local function GetFunctionServer(name: string, unreliable: boolean)
	if _G.__TOASTY_OBFUSCATE__ == true then
		name = Sha256(name)
	end

	local className = if unreliable then "UnreliableRemoteFunction" else "RemoteFunction"
	local event = GetFromPath(name, RemotesFolder, className)
	if event == nil then
		event = Instance.new(className)
		event.Name = name
		event.Parent = RemotesFolder
	end

	return event :: RemoteFunction
end

--[=[
	@function GetEventClient
	@param name string
	@return RemoteEvent
	@within InstanceManager
]=]
local function GetEventClient(name: string)
	local event, created = GetFromPath(name, RemotesFolder, "RemoteEvent")
	assert(created == false, `Could not find event {name}`)
	return event :: RemoteEvent
end

--[=[
	@function GetFunctionClient
	@param name string
	@return RemoteFunction
	@within InstanceManager
]=]
local function GetFunctionClient(name: string)
	local event, created = GetFromPath(name, RemotesFolder, "RemoteFunction")
	assert(created == false, `Could not find event {name}`)
	return event :: RemoteFunction
end

return {
	GetEventServer = GetEventServer,
	GetEventClient = GetEventClient,

	GetFunctionServer = GetFunctionServer,
	GetFunctionClient = GetFunctionClient,
}
