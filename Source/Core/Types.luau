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

export type ServerEventReciever = {
	Name: string,
	Event: RemoteEvent | UnreliableRemoteEvent,

	SetCallback: (self: ServerEventReciever, callback: (player: Player, ...any) -> ()) -> (),
}

export type ServerEventSender = {
	Name: string,
	Event: RemoteEvent | UnreliableRemoteEvent,

	Fire: (self: ServerEventSender, player: Player, ...any) -> (),
}

export type ClientEventReciever = {
	Name: string,
	Event: RemoteEvent | UnreliableRemoteEvent,

	SetCallback: (self: ServerEventReciever, callback: (player: Player, ...any) -> ()) -> (),
}

export type ClientEventSender = {
	Name: string,
	Event: RemoteEvent | UnreliableRemoteEvent,

	Fire: (self: ServerEventSender, ...any) -> (),
}

return nil
