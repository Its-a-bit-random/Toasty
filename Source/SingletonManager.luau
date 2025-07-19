local Toasty = script.Parent
local Types = require(Toasty.Types)

local Singletons: { Types.Singleton } = {}

local function Create(options: Types.SingletonOptions)
	return {
		Implements = options.Implements,
	} :: Types.Singleton
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
