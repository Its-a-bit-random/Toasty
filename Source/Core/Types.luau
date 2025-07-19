export type Singleton = {
	Implements: { string },
}

export type SingletonOptions = {
	Implements: { string },
}

export type LifecycleHandler = (singletons: { Singleton }, name: string, ...any) -> ()
export type Lifecycle = {
	Name: string,
	Dispatch: (self: Lifecycle, ...any) -> (),

	_ClassName: string,
	_OnDispatch: LifecycleHandler,
}

return nil
