local Players = game:GetService("Players")

local Core = script.Parent.Parent.Parent.Core
local Networking = script.Parent.Parent

local Types = require(Core.Types)
local InstanceManager = require(Networking.InstanceManager)

--[=[
	@class ServerEventReciever
]=]
local ServerEventReciever = {}
ServerEventReciever.__index = ServerEventReciever

--[=[
	@function new
	@within ServerEventReciever
	@param name string
	@param unreliable boolean
	@return ServerEventReciever

	Create a new server event reciever
]=]
function ServerEventReciever.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ServerEventReciever)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.Event = Instance.new(if unreliable then "UnreliableRemoteEvent" else "RemoteEvent")
	self.Event.Name = self.Name
	self.Event.Parent = InstanceManager.EventsFolder

	return self
end

--[=[
	@method SetCallback
	@within ServerEventReciever
	@param name callback (player: Player, ...any) -> ()
	@return RBXScriptConnection

	Create a new server event reciever
]=]
function ServerEventReciever.SetCallback(self: Types.ServerEventReciever, callback: (player: Player, ...any) -> ())
	local event = self.Event :: RemoteEvent
	return event.OnServerEvent:Connect(callback)
end

------------------------------------------------

--[=[
	@class ServerEventSender
]=]
local ServerEventSender = {}
ServerEventSender.__index = ServerEventSender

--[=[
	@function new
	@within ServerEventSender
	@param name string
	@param unreliable boolean
	@return ServerEventSender

	Create a new server event reciever
]=]
function ServerEventSender.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ServerEventSender)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.Event = InstanceManager.EventsFolder:FindFirstChild(name)
		or Instance.new(if unreliable then "UnreliableRemoteEvent" else "RemoteEvent")
	self.Event.Name = self.Name
	self.Event.Parent = InstanceManager.EventsFolder

	return self
end

--[=[
	@method Fire
	@within ServerEventSender
	@param player Player
	@param ... any

	Fire the underlying event for the given player
]=]
function ServerEventSender.Fire(self: Types.ServerEventSender, player: Player, ...: any)
	local event = self.Event :: RemoteEvent
	event:FireClient(player, ...)
end

--[=[
	@method FirePlayers
	@within ServerEventSender
	@param players {Player}
	@param ... any

	Fire the underlying event for the given players
]=]
function ServerEventSender.FirePlayers(self: Types.ServerEventSender, players: { Player }, ...: any)
	local event = self.Event :: RemoteEvent

	for _, player in players do
		event:FireClient(player, ...)
	end
end

--[=[
	@method Broadcast
	@within ServerEventSender
	@param ... any

	Fire the underlying event for all players in the game
]=]
function ServerEventSender.Broadcast(self: Types.ServerEventSender, ...: any)
	local event = self.Event :: RemoteEvent

	for _, player in Players:GetPlayers() do
		event:FireClient(player, ...)
	end
end

return {
	EventReciever = ServerEventReciever,
	EventSender = ServerEventSender,
}
