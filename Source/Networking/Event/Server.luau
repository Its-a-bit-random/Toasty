local Players = game:GetService("Players")

local Core = script.Parent.Parent.Parent.Core
local Networking = script.Parent.Parent

local Types = require(Core.Types)
local InstanceManager = require(Networking.InstanceManager)

--[=[
	@class ServerEventReceiver
	@server
]=]
local ServerEventReceiver = {}
ServerEventReceiver.__index = ServerEventReceiver

--[=[
	@function new
	@within ServerEventReceiver
	@param name string
	@param unreliable boolean
	@return ServerEventReceiver

	Create a new server event Receiver
]=]
function ServerEventReceiver.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ServerEventReceiver)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.Unreliable = unreliable
	InstanceManager.GetEventServer(self.Name, self.Unreliable)

	return self
end

--[=[
	@method SetCallback
	@within ServerEventReceiver
	@param callback (player: Player, ...any) -> ()
	@return RBXScriptConnection

	Sets the function that will run when the client fires the event
]=]
function ServerEventReceiver.SetCallback(self: Types.ServerEventReceiver, callback: (player: Player, ...any) -> ())
	local event = InstanceManager.GetEventServer(self.Name, self.Unreliable)
	return event.OnServerEvent:Connect(callback)
end

------------------------------------------------

--[=[
	@class ServerEventSender
	@server
]=]
local ServerEventSender = {}
ServerEventSender.__index = ServerEventSender

--[=[
	@function new
	@within ServerEventSender
	@param name string
	@param unreliable boolean
	@return ServerEventSender

	Create a new server event sender
]=]
function ServerEventSender.new(name: string, unreliable: boolean)
	local self = setmetatable({}, ServerEventSender)

	self.Name = if unreliable then "URE/" .. name else "RE/" .. name
	self.unreliable = unreliable
	InstanceManager.GetEventServer(self.Name, self.Unreliable)

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
	local event = InstanceManager.GetEventServer(self.Name, self.Unreliable)
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
	local event = InstanceManager.GetEventServer(self.Name, self.Unreliable)

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
	local event = InstanceManager.GetEventServer(self.Name, self.Unreliable)

	for _, player in Players:GetPlayers() do
		event:FireClient(player, ...)
	end
end

return {
	EventReceiver = ServerEventReceiver,
	EventSender = ServerEventSender,
}
