local CheckTableTypeResult = {
	NotTable = 0,
	SingleTable = 1,
	TableOfTables = 2,
}

local function CheckTableType<a, b>(value: { [a]: b })
	if type(value) ~= "table" then
		return CheckTableTypeResult.NotTable
	end

	local allTables = true
	for _, v in pairs(value) do
		if type(v) ~= "table" then
			allTables = false
			break
		end
	end

	return allTables and CheckTableTypeResult.TableOfTables or CheckTableTypeResult.SingleTable
end

return {
	CheckTableTypeResult = table.freeze(CheckTableTypeResult),
	CheckTableType = CheckTableType,
}
