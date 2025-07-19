local Toasty = require(game:GetService("ReplicatedStorage").Packages.Toasty)

Toasty.Networking.ServerToClientEventReciever("John"):Connect(function(message: string)
	print(message)
end)

Toasty.Bootstrap.Toast()
