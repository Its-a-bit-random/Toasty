local SingletonManager = require(script.SingletonManager)
local LifecycleManager = require(script.LifecycleManager)

return {
	Service = SingletonManager.Create,
	Controller = SingletonManager.Create,

	Lifecycle = {
		Create = LifecycleManager.Create,
	},

	Bootstrap = {
		LoadModules = function(parent: Instance, recursive: boolean)
			local possibleModules = if recursive then parent:GetDescendants() else parent:GetChildren()

			for _, module: Instance in possibleModules do
				if module:IsA("ModuleScript") then
					require(module)
				end
			end
		end,

		Toast = function()
			local onInit = LifecycleManager.Create("OnInit")
			onInit.Dispatch() -- Make this blocking

			local onStart = LifecycleManager.Create("OnStart")
			onStart.Dispatch() -- Make this parallel
		end,
	},
}
