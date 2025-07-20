---
sidebar_position: 1
---

# Configuration

Toasty can be configured using `_G` flags.

:::warning
Toasty **HAS** to be configured *before* you load any modules or call `Toast()`. This should ideally be done
first thing in runtime scripts.
:::

## `_G.__TOASTY_OBFUSCATE__`

Turning this to true obfuscates remote event/function names using `Sha256`.

:::tip
How names are obfuscated will probably change to be more secure!
:::