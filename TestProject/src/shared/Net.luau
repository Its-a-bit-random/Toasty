local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
local Net = Toasty.Networking

return {
	Events = {
		MyEvent = Net.CreateEvent({}, {}),
	},
	Functions = {
		MyFunction = Net.CreateFunction({}, {}),
	},
}
