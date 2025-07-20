local function new()
	local marker = newproxy(true)
	return marker
end

return {
	new = new,
}
