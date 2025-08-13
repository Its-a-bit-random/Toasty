local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Net = require(ReplicatedStorage.Shared.Net)

return function()
	Net.RE.Client:Fire("Test")
	return true, ""
end
