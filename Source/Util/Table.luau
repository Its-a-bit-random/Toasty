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

local function TopologicalSort(items: { [string]: any }, key: string)
	local sorted = {}
	local visited = {}

	local function visit(item)
		if visited[item] == "temp" then
			error(("Cyclic dependency detected: %s"):format(tostring(item)))
		end
		if not visited[item] then
			visited[item] = "temp"

			local deps = item[key]
			if deps then
				for _, dep in ipairs(deps) do
					visit(dep)
				end
			end

			visited[item] = true
			table.insert(sorted, item)
		end
	end

	for _, item in pairs(items) do
		visit(item)
	end

	return sorted
end

return {
	CheckTableTypeResult = table.freeze(CheckTableTypeResult),
	CheckTableType = CheckTableType,
	TopologicalSort = TopologicalSort,
}
