# Toasty Changelog

## Unreleased

* Fixed ServerFunction type
* Added proper disconnection to networking
* Added predicts to networking
* Complete rewrite of documentation
* Added new bootstrap function to automatiaclly call `Toasty.Service()` or `Toasty.Controller()` for you
* Added config system using `_G` and a Flag system
* Complete overhaul of how networking works
	* Deprecated `Networking.SetupFromModule()`; use `Networking.Setup()` instead
	* Added Unreliable `RemoteEvent`s and `RemoteFunction`s