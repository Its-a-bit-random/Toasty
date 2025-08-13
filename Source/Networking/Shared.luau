local Toasty = script.Parent.Parent
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

return {
	EventMarker = Util.Marker(),
	UnreliableEventMarker = Util.Marker(),

	FunctionMarker = Util.Marker(),
	UnreliableFunctionMarker = Util.Marker(),

	MiddlewareNextMarker = Util.Marker(),
	MiddlewareDenyMarker = Util.Marker(),

	GenerateRequestID = GenerateRequestID,
}
