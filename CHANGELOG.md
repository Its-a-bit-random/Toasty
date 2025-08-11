# Toasty Changelog

## Unreleased

* Added new bootstrap function to automatiaclly call `Toasty.Service()` or `Toasty.Controller()` for you
* Added config system using `_G` and a Flag system
* Complete overhaul of how networking works
	* Deprecated `Networking.SetupFromModule()`; use `Networking.Setup()` instead
	* Added Unreliable `RemoteEvent`s and `RemoteFunction`s