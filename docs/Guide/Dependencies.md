---
sidebar_position: 3
---

# Dependencies

## Dependencies

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

## Custom load order

You can pass a custom load order into singletons using `LoadOrder`. By default all singletons are on load order 2. The higher the `LoadOrder` the later the singleton will load. If you want some singletons to always load before any other ones you can pass in a `LoadOrder` of 1.

:::warning
Toasty wont warn you but if your singleton is a LoadOrder = 1, but it has a dependency that is LoadOrder = 2, Toasty may not start your singletons in the right order!
:::