local Toasty = script.Parent
local Types = require(Toasty.Types)
local SingletonManagerModule = require(Toasty.SingletonManager)
local GetAll = SingletonManagerModule.GetAll

local function DispatchImplement(implement: string, ...: any)
	local args = { ... }
	local singletons = GetAll()

	for _, v in singletons do
		if table.find(v.Implements, implement) then
			local foundFunc = v[implement] :: (self: Types.Singleton, ...any) -> ()?
			assert(foundFunc ~= nil, `Singleton implements {implement} but has no function`)
			task.spawn(foundFunc, v, table.unpack(args))
		end
	end
end

local function Create(name: string)
	return {
		_ClassName = "LIFECYCLE", -- Maybe switch this index to be a symbol
		Name = name,
		Dispatch = function(...: any)
			local args = { ... }

			local firstArg = args[1]
			if firstArg ~= nil then
				local className = firstArg["_ClassName"]
				if className ~= nil and className == "LIFECYCLE" then
					error("Dispatch must be called with dot notation")
				end
			end

			DispatchImplement(name, ...)
		end,
	} :: Types.Lifecycle
end

return {
	Create = Create,
}
