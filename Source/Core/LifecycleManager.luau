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

local function DefaultDispatch(singletons: { Types.Singleton }, name: string, ...: any)
	local args = { ... }

	for _, v in singletons do
		local foundFunc = v[name] :: (self: Types.Singleton, ...any) -> ()?
		task.spawn(foundFunc, v, table.unpack(args))
	end
end

local function Create(name: string, onDispatch: (singletons: { Types.Singleton }, name: string, ...any) -> ()?)
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

			if onDispatch then
				onDispatch(GetSingletonsWhichImplement(name), name, table.unpack(args))
			else
				DefaultDispatch(GetSingletonsWhichImplement(name), name, table.unpack(args))
			end
		end,
	} :: Types.Lifecycle
end

return {
	Create = Create,
}
