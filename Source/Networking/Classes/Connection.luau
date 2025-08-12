local Signal = require(script.Parent.Parent.Parent.Parent.Signal)

--[=[
	@class Connection
]=]
local Connection = {}
Connection.__index = Connection

export type Connection = {
	Disconnect: (self: Connection) -> (),

	_RbxConn: RBXScriptConnection,
	_Disconnectd: Signal.Signal<>,
}

--[=[
	@function new
	@param conn RBXScriptConnection
	@within Connection
]=]
function Connection.new(conn: RBXScriptConnection)
	local self = setmetatable({}, Connection)
	self._RbxConn = conn
	self._Disconnectd = Signal.new()
	return self :: Connection
end

--[=[
	@method Disconnect
	@within Connection
]=]
function Connection.Disconnect(self: Connection)
	self._RbxConn:Disconnect()
	self._Disconnectd:Fire()
end

return {
	Connection = Connection.new,
}
