return function()
	local first = require(script.Parent.Parent.Singletons.First)
	local second = require(script.Parent.Parent.Singletons.Second)

	local fld = first["_METADATA_LOAD_ORDER_INDEX"]
	local sld = second["_METADATA_LOAD_ORDER_INDEX"]

	if fld > sld then
		return false, "Wrong load order"
	end

	return true, ""
end
