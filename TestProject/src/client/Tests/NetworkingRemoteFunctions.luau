local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)
local Toasty = require(ReplicatedStorage.Packages.Toasty)
local Net = require(ReplicatedStorage.Shared.Net)

return function()
	local result = true
	local reason = ""

	Net.RF.Client
		:Fire({
			Toasty.Networking.Arg.string,
		}, "Hello!")
		:timeout(5)
		:catch(function(e)
			result = false
			if Promise.Error.isKind(e, Promise.Error.Kind.TimedOut) then
				reason = "Server timed out (took longer than 5 sec to respond)"
			else
				reason = "Promise error"
			end
		end)
		:await()

	return result, reason
end
