---
sidebar_position: 3
---

# Dependencies

**The Toasty dependency system is completely optional but is recommended** since it ensures your singletons are loaded and started in the correct order.

To tell Toasty your singleton has a dependency on another singleton simply pass it into a dependencies table of your singleton. Example:

```lua
local MyOtherService = require(path.to.OtherService)

local MyService = {
	Implements = { "OnStart" };
	Dependencies = { MyOtherService };
}

function MyService:OnStart()
	print("Hello World!")
	MyOtherService:Foo()
end

return MyService
```

Now toasty will call `OnInit` for MyOtherService before `OnInit` for MyService. Same with for `OnStart`. 