local Core = script.Parent
local Types = require(Core.Types)

local Singletons: { Types.Singleton } = {}

--[=[
	@class SingletonManager
	Handles the creation and tracking of all singeltons created
]=]

--[=[
	@function Create
	@within SingletonManager
	@param options SingletonOptions
	@return Singleton

	Creates a new singelton
]=]
local function Create(options: Types.SingletonOptions)
	local newSingleton = {
		Implements = options.Implements,
	} :: Types.Singleton

	table.insert(Singletons, newSingleton)

	return newSingleton
end

--[=[
	@function GetAll
	@within SingletonManager
	@return { Singleton }

	Returns an array of all singletons created
]=]
local function GetSingletons(): { Types.Singleton }
	local frozenSingletons = table.clone(Singletons)
	table.freeze(frozenSingletons)
	return frozenSingletons
end

return {
	Create = Create,
	GetAll = GetSingletons,
}
