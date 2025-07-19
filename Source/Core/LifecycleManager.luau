local Core = script.Parent
local Types = require(Core.Types)

local Lifecycle = require(Core.Lifecycle)

local function DefaultHandler(singletons: { Types.Singleton }, name: string, ...: any)
	local args = { ... }

	for _, v in singletons do
		local foundFunc = v[name] :: (self: Types.Singleton, ...any) -> ()?
		task.spawn(foundFunc, v, table.unpack(args))
	end
end

local function Create(name: string, handler: Types.LifecycleHandler?)
	local handlerToUse: Types.LifecycleHandler = if handler then handler else DefaultHandler
	return Lifecycle.new(name, handlerToUse)
end

return {
	Create = Create,
}
