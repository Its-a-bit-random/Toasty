# Toasty Changelog

## Unreleased

* Proper testing system ([#6])
* Fixed `.rbxm` workflow to have types in packages
* Fixed docs spelling

[#6]: https://github.com/Its-a-bit-random/Toasty/pull/6

## 1.0.0

* Fixed ServerFunction type
* Added proper disconnection to networking
* Added predicts to networking
* Complete rewrite of documentation
* Added new bootstrap function to automatically call `Toasty.Service()` or `Toasty.Controller()` for you
* Added config system using `_G` and a Flag system
* Complete overhaul of how networking works
	* Deprecated `Networking.SetupFromModule()`; use `Networking.Setup()` instead
	* Added Unreliable `RemoteEvent`s and `RemoteFunction`s