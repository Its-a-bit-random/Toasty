# Toasty

A powerful Luau game framework inspired by Flamework for Roblox-TS. Toasty is intended to be the most advanced framework for luau while maintaining a simple API.

## Features

- Networking system with automatic runtime type-checking
- Service/Controller architecture similar to `Knit`
- Automatic dependency load order (optional)
- Lifecycle system with support for creating custom lifecycle events

...and more coming the future!

## Installing

Toasty can be installed via 2 methods at the moment. Via Wally (package manager) or via a `.rbxm` file. Follow the below instructions for your preferred method.

### Wally

Add the following to your `wally.toml` file:
```toml
[dependencies]
Toasty = "its-a-bit-random/toasty@1.1.0"
```
and run
```sh
wally install
```
Make sure to sync your Packages folder with Rojo and your ready to go.

### Roblox Studio: `.rbxm`

If you want to use Toasty directly in Roblox Studio without Rojo or Wally you must first install the latest `Toasty.rbxm` from [here](https://github.com/Its-a-bit-random/Toasty/releases/latest).

Once tou have that downloaded drag and drop that file into studio and move the `Packages` folder into ReplicatedStorage.

This is the exact equivalent of doing the Wally install method but done for you and is intended to be used with non-rojo managed games.