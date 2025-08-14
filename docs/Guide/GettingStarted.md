---
sidebar_position: 1
---

# Getting Started

You have decided to use Toasty for your next project, Amazing. Before we go into how to use Toasty and all of its features we need to first understand what Toasty is and what it aims to do.

Toasty is a ROBLOX Luau game framework inspired by Flamework for Roblox-TS. Toasty aims to be a powerful framework that allows you to spend less time writing boilerplate code and spend more time writing actual game logic.

Finally Toasty is a Single-Script Framework. This means that you are only meant to have 1 Server Script and 1 Local Script and the rest of your logic stored in Module Scripts. If you dont understand what this means or the benefits of it you will learn very quickly why toasty does this.

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