local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Promise = require(ReplicatedStorage.Packages.Promise)
local Signal = require(ReplicatedStorage.Packages.Signal)
local Toasty = require(ReplicatedStorage.Packages.Toasty)

return function()
	local result, reason = true, ""

	local lf = Toasty.Lifecycle.Create("TEST_LIFECYCLE")
	local lf_sig = Signal.new()

	Promise.delay(1):andThen(function()
		lf:Dispatch(lf_sig, 5)
	end)

	Promise.fromEvent(lf_sig)
		:andThen(function(got: number)
			if got ~= 5 then
				result = false
				reason = "Incorrect value passed"
			else
				result = true
			end
		end)
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
