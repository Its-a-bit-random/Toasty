local SingletonManager = require(script.SingletonManager)
local LifecycleManager = require(script.LifecycleManager)

return {
	Service = SingletonManager.Create,

	Lifecycle = {
		Create = LifecycleManager.Create,
	},
}
