local Core = script.Parent.Parent.Parent.Core
local Networking = script.Parent.Parent

local Types = require(Core.Types)
local InstanceManager = require(Networking.InstanceManager)

--[=[
	@class ClientEventReceiver
	@client
]=]
local ClientEventReceiver = {}
ClientEventReceiver.__index = ClientEventReceiver

--[=[
	@function new
	@within ClientEventReceiver
	@param name string
	@param unreliable boolean
	@return ClientEventReceiver

	Create a new client event Receiver
]=]
function ClientEventReceiver.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ClientEventReceiver)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.Event = InstanceManager.EventsFolder:WaitForChild(self.Name, 10)
	assert(self.Event ~= nil, `Event {self.Name} could not be found`)

	return self
end

--[=[
	@method SetCallback
	@within ClientEventReceiver
	@param callback (...any) -> ()
	@return RBXScriptConnection

	Sets the function that will run when the event is fired from the server
]=]
function ClientEventReceiver.SetCallback(self: Types.ClientEventReceiver, callback: (...any) -> ())
	local event = self.Event :: RemoteEvent
	return event.OnClientEvent:Connect(callback)
end

------------------------------------------------

--[=[
	@class ClientEventSender
	@client
]=]
local ClientEventSender = {}
ClientEventSender.__index = ClientEventSender

--[=[
	@function new
	@within ClientEventSender
	@param name string
	@param unreliable boolean
	@return ClientEventSender

	Create a new client event sender
]=]
function ClientEventSender.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ClientEventSender)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.Event = InstanceManager.EventsFolder:WaitForChild(self.Name, 10)
	assert(self.Event ~= nil, `Event {self.Name} could not be found`)

	return self
end

--[=[
	@method Fire
	@within ClientEventSender
	@param ... any

	Fire the underlying event to the server
]=]
function ClientEventSender.Fire(self: Types.ClientEventSender, ...: any)
	local event = self.Event :: RemoteEvent
	event:FireServer(...)
end

return {
	EventReceiver = ClientEventReceiver,
	EventSender = ClientEventSender,
}
