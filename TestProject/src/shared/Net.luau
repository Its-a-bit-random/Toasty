local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
local Net = Toasty.Networking

return {
	RE = Net.Event(),
	URE = Net.UnreliableEvent(),
	RF = Net.Function(),
	URF = Net.UnreliableFunction(),
}
