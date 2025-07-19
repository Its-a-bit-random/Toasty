local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

Toasty.Bootstrap.LoadModules(script.Services, true)
Toasty.Bootstrap.Toast()

for i = 1, 5, 1 do
	print(i)
	task.wait(1)
end

Toasty.Networking.ServerToClientEventSender("John"):Broadcast("John")
