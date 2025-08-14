local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Flags = require("@Toasty/Flags")
local Util = require("@Toasty/Util")

local RemotesFolder: Folder

if RunService:IsServer() then
	RemotesFolder = Instance.new("Folder")
	RemotesFolder.Name = "Remotes"
	RemotesFolder.Parent = ReplicatedStorage
else
	RemotesFolder = ReplicatedStorage:WaitForChild("Remotes", 5)
	assert(RemotesFolder ~= nil, "Client could not find remotes folder")
end

local function GetFromPathNested(path: string, root: Instance, className: string)
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

local function GetFromPathFlat(path: string, root: Instance, className: string)
	local splitPath = path:split("/")
	local instanceName = splitPath[#splitPath]

	local attribName = "__TOASTY_NET_PATH__"
	local foundInstance = Util.Attribute.FindFirstChildWithAttribute(root, attribName, path)

	if foundInstance then
		return foundInstance, false
	end

	local newInstance = Instance.new(className)
	newInstance.Name = instanceName
	newInstance.Parent = root
	newInstance:SetAttribute(attribName, path)

	return newInstance, true
end

local function GetFromPath(path: string, root: Instance, className: string)
	if Flags.IsEnabled(Flags.Flags.FlatNetworkStructure) then
		return GetFromPathFlat(path, root, className)
	else
		return GetFromPathNested(path, root, className)
	end
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
	local className = if unreliable then "UnreliableRemoteEvent" else "RemoteEvent"
	local event = GetFromPath(name, RemotesFolder, className)
	if event == nil then
		event = Instance.new(className)
		event.Name = name
		event.Parent = RemotesFolder

		if Flags.IsEnabled(Flags.Flags.Verbose) then
			print("[TOASTY::NETWORKING]", "Created", className)
		end
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
	local event = GetEventServer(name, unreliable)
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
