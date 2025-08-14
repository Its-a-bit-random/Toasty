local Types = require("@core/Types")
local Lifecycle = require("@core/Lifecycle")

local function DefaultHandler(singletons: { Types.Singleton }, name: string, ...: any)
	local args = { ... }

	for _, v in singletons do
		local foundFunc = v[name] :: (self: Types.Singleton, ...any) -> ()?
		task.spawn(foundFunc, v, table.unpack(args))
	end
end

--[=[
	@class LifecycleManager
]=]

--[=[
	@function Create
	@within LifecycleManager
	@param name string
	@param handler LifecycleHandler?
	@return Lifecycle
	
	Create a new lifecycle event. Creating it via the manager makes the passing a
	handler optional as it provides one by default.
]=]
local function Create(name: string, handler: Types.LifecycleHandler?)
	local handlerToUse: Types.LifecycleHandler = if handler then handler else DefaultHandler
	return Lifecycle.new(name, handlerToUse)
end

return {
	Create = Create,
}
