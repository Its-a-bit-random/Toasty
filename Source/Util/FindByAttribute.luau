local function FindFirstChildWithAttribute(parent: Instance, attribute: string, value: any)
	for _, child in parent:GetChildren() do
		if child:GetAttribute(attribute) == value then
			return child
		end
	end

	return nil
end

local function WaitForChildWithAttribute(parent: Instance, attribute: string, value: any)
	local instance = FindFirstChildWithAttribute(parent, attribute, value)

	local watcherThread = task.delay(5, function()
		warn(
			`Toasty is waiting on a child of {parent:GetFullName()} with attribute of {attribute} with value of {value}`
		)
	end)

	if not instance then
		local thread = coroutine.running()
		local conn
		conn = parent.ChildAdded:Connect(function(child: Instance)
			if child:GetAttribute(attribute) == value then
				conn.Disconnect()
				task.spawn(thread, child)
			end
		end)

		instance = select(1, coroutine.yield(thread))
	end

	task.cancel(watcherThread)
	return instance
end

return {
	FindFirstChildWithAttribute = FindFirstChildWithAttribute,
	WaitForChildWithAttribute = WaitForChildWithAttribute,
}
