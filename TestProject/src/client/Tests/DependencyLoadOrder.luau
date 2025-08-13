return function()
	local first = require(script.Parent.Parent.Singletons.First)
	local second = require(script.Parent.Parent.Singletons.Second)

	if first["_METADATA_LOAD_ORDER_INDEX"] ~= 1 then
		return false, "Incorrect load order"
	end

	if second["_METADATA_LOAD_ORDER_INDEX"] ~= 2 then
		return false, "Incorrect load order"
	end

	return true, ""
end
