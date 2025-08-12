local SingletonManager = require(script.Core.SingletonManager)
local LifecycleManager = require(script.Core.LifecycleManager)

--[=[
	@class Toasty
	Entry point of Toasty framework
]=]

--[=[
	@function Service
	@param options SingletonOptions
	@return Singleton
	@within Toasty

	Creates a new singleton through the [SingletonManager]
]=]

--[=[
	@function Controller
	@param options SingletonOptions
	@return Singleton
	@within Toasty

	Creates a new singleton through the [SingletonManager]
]=]

--[=[
	@function Lifecycle.Create
	@param name string
	@param handler LifecycleHandler?
	@return Lifecycle
	@within Toasty

	Create a new lifecycle event via the [LifecycleManager]


	Here is am exmaple of a custom `OnHeartbeat` lifecycle
	
	```lua
	-- Services/HeartbeatLifecycleService
	local RunService = game:GetService("RunService")
	local Toasty = require(path.to.Toasty)
		
	local HeartbeatLifecycleService = {
		Implements = { "OnStart" }
	}
		
	function HeartbeatLifecycleService:OnStart()
		local heartbeatLifecycle = Toasty.Lifecycle.Create("OnHeartbeat")
	
		RunService.Heartbeat:Connect(function(deltaTime)
			heartbeatLifecycle:Dispatch(deltaTime)
		end)
	end
	
	return HeartbeatLifecycleService

	
	-- Services/MyService.luau
	local MyFirstService = {
		Implements = { "OnHeartbeat" };
	}

	--[[
		Add in the function wich gets called when the lifecycle
		is dispatched
	]]
	function MyFirstService:OnHeartbeat(deltaTime: number)
		print("Heartbeat, dt =", deltaTime)
	end

	return MyFirstService
	```
]=]

--[=[
	@prop Bootstrap Bootstrap
	@readonly
	@within Toasty
]=]

--[=[
	@prop Networking Networking
	@readonly
	@within Toasty
]=]

--[=[
	@prop Flags Flags
	@readonly
	@within Toasty
]=]

return {
	Service = SingletonManager.Create,
	Controller = SingletonManager.Create,

	Lifecycle = {
		Create = LifecycleManager.Create,
	},

	Bootstrap = require(script.Bootstrap),
	Networking = require(script.Networking),
	Flags = require(script.Flags),
}
