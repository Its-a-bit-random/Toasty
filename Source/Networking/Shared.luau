local Toasty = script.Parent.Parent
local Types = require(script.Parent.Parent.Core.Types)
local Flags = require(script.Parent.Parent.Flags)
local Util = require(Toasty.Util)

--[=[
	@type TypeCheckFunc (...any) -> (boolean, string?)
	@within Networking
]=]
export type TypeCheckFunc = (...any) -> (boolean, string?)

--[=[
	@interface EventTable
	.Instance RemoteEvent | RemoteFunction | nil
	.Inputs { TypeCheckFunc }
	.Outputs { TypeCheckFunc }
	@within Networking
]=]
export type EventTable = {
	Instance: RemoteEvent | RemoteFunction | nil,
}

export type NetworkingTable = { [string]: EventTable | { EventTable } }

--[=[
	@ignore
	@within Networking

	This is a temp function while I figure out a better solution,
	This shouldnt have too big of an impact on performance and/or
	sizes.
]=]
local function GenerateRequestID()
	local timePart = string.format("%x", math.floor(os.clock() * 1000))
	local randPart = string.format("%03x", math.random(0, 4095))
	return timePart .. randPart
end

local MiddlewareNextMarker = Util.Marker()
local MiddlewareDenyMarker = Util.Marker()

--[=[
	@ignore
	@within Networking

	Runs the passed middleware functions
]=]
local function RunMiddleware(middleware: { Types.MiddlewareFn }, args: { any })
	for _, fn in ipairs(middleware) do
		local deny = false

		local success, errorMessage = pcall(function()
			local result = fn(MiddlewareDenyMarker, MiddlewareNextMarker, args)

			if result == MiddlewareDenyMarker then
				deny = true
			elseif result == MiddlewareNextMarker then
				deny = false
			else
				error("Invalid result")
			end
		end)

		if not success then
			deny = true
			if Flags.IsEnabled(Flags.Flags.WarnOnMiddlewareError) then
				warn("Failed to run middleware:", errorMessage)
			else
				error("Failed to run middleware:", errorMessage)
			end
		end

		if deny then
			error("Middleware denied request")
			return MiddlewareDenyMarker
		end
	end

	return MiddlewareNextMarker
end

return {
	EventMarker = Util.Marker(),
	UnreliableEventMarker = Util.Marker(),

	FunctionMarker = Util.Marker(),
	UnreliableFunctionMarker = Util.Marker(),

	MiddlewareNextMarker = MiddlewareNextMarker,
	MiddlewareDenyMarker = MiddlewareDenyMarker,

	GenerateRequestID = GenerateRequestID,
	RunMiddleware = RunMiddleware,
}
