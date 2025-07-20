local Toasty = script.Parent.Parent
local Util = require(Toasty.Util)

export type TypeCheckFunc = (...any) -> (boolean, string?)

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
