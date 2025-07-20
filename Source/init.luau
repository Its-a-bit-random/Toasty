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
]=]

--[=[
	@prop Bootstrap Bootstrap
	@within Toasty
]=]

--[=[
	@function Networking.ServerEventSender
	@param name string
	@param unreliable boolean
	@return ServerEventSender
	@within Toasty
]=]

--[=[
	@function Networking.ServerEventReceiver
	@param name string
	@param unreliable boolean
	@return ServerEventReceiver
	@within Toasty
]=]

--[=[
	@function Networking.ClientEventSender
	@param name string
	@param unreliable boolean
	@return ClientEventSender
	@within Toasty
]=]

--[=[
	@function Networking.ClientEventReceiver
	@param name string
	@param unreliable boolean
	@return ClientEventReceiver
	@within Toasty
]=]

return {
	Service = SingletonManager.Create,
	Controller = SingletonManager.Create,

	Lifecycle = {
		Create = LifecycleManager.Create,
	},

	Bootstrap = require(script.Bootstrap),

	Networking = {
		ServerEventSender = require(script.Networking.Event.Server).EventSender.new,
		ServerEventReceiver = require(script.Networking.Event.Server).EventReceiver.new,

		ClientEventSender = require(script.Networking.Event.Client).EventSender.new,
		ClientEventReceiver = require(script.Networking.Event.Client).EventReceiver.new,
	},
}
