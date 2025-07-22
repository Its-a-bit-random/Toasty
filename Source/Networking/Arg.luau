--[=[
	@class Arg
]=]

local function IsType(thing: any, expected: string)
	return type(thing) == expected
end

local function IsNil(thing: any)
	return thing == nil
end

--[=[
	@function string
	@param arg any
	@return boolean
	@within Arg
]=]

--[=[
	@function number
	@param arg any
	@return boolean
	@within Arg
]=]

return {
	string = function(arg: any)
		return not IsNil(arg) and IsType(arg, "string")
	end,

	number = function(arg: any)
		return not IsNil(arg) and IsType(arg, "number")
	end
}