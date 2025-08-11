--[=[
	@class Flags
	Flags are a way of turning on or off Developer or Experimental features of Toasty.
	All flags are documented [Here](../docs/Guide/Config)
]=]

--[=[
	@type Flag string
	@within Flags
]=]

--[=[
	@interface Flags
	.Verbose Flag
	@within Flags
]=]

--[=[
	@prop Flags Flags
	@readonly
	@within Flags
]=]
local Flags = {
	["Verbose"] = "Verbose",
}
table.freeze(Flags)

local function CreateGlobalKey(str: string)
	local PREFIX = "__TOASTY_"
	local key = str:upper()
	local SUFFEX = "__"

	return `{PREFIX}{key}{SUFFEX}`
end

--[=[
	@param flag Flag
	@within Flags
]=]
local function Enable(flag: string)
	local key = CreateGlobalKey(flag)
	_G[key] = true
end

--[=[
	@param flag Flag
	@within Flags
]=]
local function Disable(flag: string)
	local key = CreateGlobalKey(flag)
	_G[key] = false
end

--[=[
	@param flag Flag
	@within Flags
]=]
local function IsEnabled(flag: string)
	local key = CreateGlobalKey(flag)
	return _G[key] == true
end

return {
	Enable = Enable,
	Disable = Disable,
	IsEnabled = IsEnabled,
	Flags = Flags,
}
