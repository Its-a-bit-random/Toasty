local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Toasty = require(ReplicatedStorage.Packages.Toasty)
Toasty.Flags.Enable(Toasty.Flags.Flags.FlatNetworkStructure)
Toasty.Networking.Setup(ReplicatedStorage.Shared.Net)

task.wait(1)

print(string.rep("=", 50))
print("STARTING TESTS")
print(string.rep("=", 50))

local TestScripts = script.Tests:GetChildren() :: { ModuleScript }
for i, test in pairs(TestScripts) do
	local run = require(test)
	local passed, failReason

	local runPass, runError = pcall(function()
		passed, failReason = run()
	end)

	if not runPass then
		print(`[{i}/{#TestScripts}] {test.Name}: TEST FAILED ❌`)
		warn("ERROR WHILE RUNNING TEST")
		warn(runError)
		continue
	end

	if passed then
		print(`[{i}/{#TestScripts}] {test.Name}: TEST PASSED ✅`)
	else
		print(`[{i}/{#TestScripts}] {test.Name}: TEST FAILED ❌`)
		warn(failReason)
	end
end

print(string.rep("=", 50))
print("TESTS FINISHED")
print(string.rep("=", 50))
