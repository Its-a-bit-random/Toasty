local SingletonManager = require(script.Core.SingletonManager)
local LifecycleManager = require(script.Core.LifecycleManager)

local Networking = require(script.Networking)

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
			local onInit = LifecycleManager.Create("OnInit", function(singletons, name: string, ...: any)
				for _, v in singletons do
					local func = v[name]
					func(v, ...)
				end
			end)
			onInit:Dispatch()

			local onStart = LifecycleManager.Create("OnStart", function(singletons, name: string, ...: any)
				for _, v in singletons do
					local func = v[name]
					task.spawn(func, v, ...)
				end
			end)
			onStart:Dispatch()
		end,
	},

	Networking = {
		ServerToClientEventReciever = Networking.ServerToClientReciever,
		ServerToClientEventSender = Networking.ServerToClientSender,
	},
}
