---
sidebar_position: 6
---

# Configuration

Toasty can be configured via `_G` with "Flags", since its annoying to write certain key's for `_G` Toasty exports a Flags API to help with this.

Your flags should be enabled first thing after requiring Toasty. See the [Flags API](/api/Flags) to learn how to enable/disable flags. 

See below a list of all flags and what they do:

## `Toasty.Flags.Flags.Verbose`

Enables loggging for toasty to let you know exactly whats going on and when.

## `Toasty.Flags.Flags.FlatNetworkStructure`

When toasty creates your networking instances, they by default get put into folders which match to the same strucutre defined in your Network module. By turning this flag on Toasty just dumps all your network events into the remotes folder.

:::tip
With this enabled events with the same name can still exist.
:::