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
	Inputs: { TypeCheckFunc },
	Outputs: { TypeCheckFunc },
}

export type NetworkingTable = {
	Events: { [string]: EventTable | { EventTable } },
	Functions: { [string]: EventTable | { EventTable } },
}

return {
	EventMarker = Util.Marker(),
	FunctionMarker = Util.Marker(),
}
