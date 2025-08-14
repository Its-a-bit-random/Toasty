local RunService = game:GetService("RunService")
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
	@interface PossibleFlags
	.Verbose Flag
	.FlatNetworkStructure Flag
	.WarnOnMiddlewareError Flag
	@within Flags
]=]

--[=[
	@prop Flags PossibleFlags
	@readonly
	@within Flags
]=]
local Flags = {
	["Verbose"] = "Verbose",
	["FlatNetworkStructure"] = "FlatNetworkStructure",
	["WarnOnMiddlewareError"] = "WarnOnMiddlewareError",
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

-- DEFAULT FLAGS --

if RunService:IsStudio() then
	Enable(Flags.WarnOnMiddlewareError)
end

return {
	Enable = Enable,
	Disable = Disable,
	IsEnabled = IsEnabled,
	Flags = Flags,
}
