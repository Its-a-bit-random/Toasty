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
	@readonly
	@within Toasty
]=]

--[=[
	@prop Networking Networking
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
}
