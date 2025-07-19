local Core = script.Parent
local Types = require(Core.Types)

local SingletonManagerModule = require(Core.SingletonManager)
local GetAll = SingletonManagerModule.GetAll

local function GetSingletonsWhichImplement(lifecycle: string)
	local singletons = GetAll()
	local singletonsWhichImplement = {}

	for _, v in singletons do
		if table.find(v.Implements, lifecycle) then
			local foundFunc = v[lifecycle] :: (self: Types.Singleton, ...any) -> ()?
			assert(foundFunc ~= nil, `Singleton implements {lifecycle} but has no function`)
			table.insert(singletonsWhichImplement, v)
		end
	end

	return singletonsWhichImplement
end

local Lifecycle = {}
Lifecycle.__index = Lifecycle

function Lifecycle.new(name: string, handler: Types.LifecycleHandler)
	local self = setmetatable({}, Lifecycle)

	self.Name = name
	self._OnDispatch = handler

	return self :: Types.Lifecycle
end

function Lifecycle.Dispatch(self: Types.Lifecycle, ...: any)
	local singletons = GetSingletonsWhichImplement(self.Name)
	self._OnDispatch(singletons, self.Name, ...)
end

return {
	new = Lifecycle.new,
}
