--[=[
	@class Types
	All types used by Toasty
]=]

--[=[
	@interface Singleton
	.Implements { string }
	.Dependencies { Singleton }
	.LoadOrder number
	@within Types
]=]
export type Singleton = {
	Implements: { string },
	Dependencies: { Singleton },
	LoadOrder: number,
}

--[=[
	@interface SingletonOptions
	.Implements { string }?
	.Dependencies { Singleton }?
	.LoadOrder number?
	@within Types
]=]
export type SingletonOptions = {
	Implements: { string }?,
	Dependencies: { Singleton }?,
	LoadOrder: number?,
}

--[=[
	@type LifecycleHandler (singletons: { Singleton }, name: string, ...any) -> ()
	@within Types
]=]
export type LifecycleHandler = (singletons: { Singleton }, name: string, ...any) -> ()
export type Lifecycle = {
	Name: string,
	Dispatch: (self: Lifecycle, ...any) -> (),

	_ClassName: string,
	_OnDispatch: LifecycleHandler,
}

--[=[
	@type Marker {}
	@within Types
]=]
export type Marker = {}

--[=[
	@since v1.1.0
	@type MiddlewareFn (deny: Marker, next: Marker, args: {[number]: any}) -> Marker
	@within Types
	The Args table is the Args that are passed to the event callback. Any modifications to these
	are retained to the next middleware and eventually to the callback.
]=]
export type MiddlewareFn = (deny: Marker, next: Marker, { [number]: any }) -> Marker

return nil
