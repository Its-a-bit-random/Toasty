local Core = script.Parent.Parent.Parent.Core
local Networking = script.Parent.Parent

local Types = require(Core.Types)
local InstanceManager = require(Networking.InstanceManager)

--[=[
	@class ClientEventReciever
]=]
local ClientEventReciever = {}
ClientEventReciever.__index = ClientEventReciever

--[=[
	@function new
	@within ClientEventReciever
	@param name string
	@param unreliable boolean
	@return ClientEventReciever

	Create a new server event reciever
]=]
function ClientEventReciever.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ClientEventReciever)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.Event = InstanceManager.EventsFolder:WaitForChild(self.Name, 10)
	assert(self.Event ~= nil, `Event {self.Name} could not be found`)

	return self
end

--[=[
	@method SetCallback
	@within ClientEventReciever
	@param name callback (...any) -> ()
	@return RBXScriptConnection

	Create a new server event reciever
]=]
function ClientEventReciever.SetCallback(self: Types.ClientEventReciever, callback: (...any) -> ())
	local event = self.Event :: RemoteEvent
	return event.OnClientEvent:Connect(callback)
end

------------------------------------------------

--[=[
	@class ClientEventSender
]=]
local ClientEventSender = {}
ClientEventSender.__index = ClientEventSender

--[=[
	@function new
	@within ClientEventSender
	@param name string
	@param unreliable boolean
	@return ClientEventSender

	Create a new server event reciever
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

	Fire the underlying event for the given player
]=]
function ClientEventSender.Fire(self: Types.ClientEventSender, ...: any)
	local event = self.Event :: RemoteEvent
	event:FireServer(...)
end

return {
	EventReciever = ClientEventReciever,
	EventSender = ClientEventSender,
}
