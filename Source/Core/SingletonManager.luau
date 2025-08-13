local Core = script.Parent
local Types = require(Core.Types)
local Flags = require(script.Parent.Parent.Flags)

local Singletons: { Types.Singleton } = {}

--[=[
	@class SingletonManager
	Handles the creation and tracking of all singletons created
]=]

--[=[
	@function Create
	@within SingletonManager
	@param options SingletonOptions
	@return Singleton

	Creates a new singleton
]=]
local function Create(options: Types.SingletonOptions)
	if options.Implements == nil then
		options.Implements = {}
	end

	if options.Dependencies == nil then
		options.Dependencies = {}
	end

	local newSingleton = options :: Types.Singleton
	table.insert(Singletons, newSingleton)
	if Flags.IsEnabled(Flags.Flags.Verbose) then
		print("[TOASTY]", "Registered new singleton")
	end
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
