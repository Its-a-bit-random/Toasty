--[=[
	@class Types
	All types used by Toasty
]=]

--[=[
	@interface Singleton
	.Implements { string }
	.Dependencies { Singleton }
	@within Types
]=]
export type Singleton = {
	Implements: { string },
	Dependencies: { Singleton },
}

--[=[
	@interface SingletonOptions
	.Implements { string }?
	.Dependencies { Singleton }?
	@within Types
]=]
export type SingletonOptions = {
	Implements: { string }?,
	Dependencies: { Singleton }?,
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

export type ServerEventReceiver = {
	Name: string,
	Unreliable: boolean,

	SetCallback: (self: ServerEventReceiver, callback: (player: Player, ...any) -> ()) -> (),
}

export type ServerEventSender = {
	Name: string,
	Unreliable: boolean,

	Fire: (self: ServerEventSender, player: Player, ...any) -> (),
	FirePlayers: (self: ServerEventSender, players: { Player }, ...any) -> (),
	Broadcast: (self: ServerEventSender, ...any) -> (),
}

export type ClientEventReceiver = {
	Name: string,

	SetCallback: (self: ServerEventReceiver, callback: (player: Player, ...any) -> ()) -> (),
}

export type ClientEventSender = {
	Name: string,

	Fire: (self: ServerEventSender, ...any) -> (),
}

return nil
