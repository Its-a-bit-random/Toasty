---
sidebar_position: 1
---

# Configuration

Toasty can be configured using `_G`. Since this can get annoying to do Toasty exports a [Flags](/api/Flags) module which has functions and whatnot to make configs very simple.

## Flags

### Verbose

Makes toasty print out everything its doing into console.

### FlatNetworkStructure

When creating remote events toasty just dumps them all into the Remotes folder rather than keeping structure defined in your `Networking` module.

In Flamework this is the default behaviour however with Toasty it is disabled by default and can be enabled using this Feature Flag.