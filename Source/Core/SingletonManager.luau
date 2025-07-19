local Core = script.Parent
local Types = require(Core.Types)

local Singletons: { Types.Singleton } = {}

local function Create(options: Types.SingletonOptions)
	local newSingleton = {
		Implements = options.Implements,
	} :: Types.Singleton

	table.insert(Singletons, newSingleton)

	return newSingleton
end

local function GetSingletons(): { Types.Singleton }
	local frozenSingletons = table.clone(Singletons)
	table.freeze(frozenSingletons)
	return frozenSingletons
end

return {
	Create = Create,
	GetAll = GetSingletons,
}
