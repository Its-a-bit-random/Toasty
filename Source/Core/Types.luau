--[=[
	@class Types
	All types used by Toasty
]=]

--[=[
	@interface Singleton
	.Implements { string }
	@within Types
]=]
export type Singleton = {
	Implements: { string },
}

--[=[
	@interface SingletonOptions
	.Implements { string }
	@within Types
]=]
export type SingletonOptions = {
	Implements: { string },
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

return nil
