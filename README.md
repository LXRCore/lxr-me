<img src="https://raw.githubusercontent.com/LXRCore/.github/main/profile/lxrcore-logo.png" alt="LXRCore" width="72" align="left" style="margin-right:12px">

# lxr-me — roleplay text overlay for LXRCore

`/me` (from lxr-core), plus `/do`, `/try` and `/whisper`, drawn above the
speaker's head through a NUI overlay with a bundled Georgian-capable font
(the LXR UI Kit's Inter + Noto Sans Georgian). RDR3's native 3D text shows boxes for Georgian;
this shows the words.

* One frame-loop that only runs while a line is on screen (0.00 ms idle).
* Lines stack per player, scale with distance, fade in/out, hide in the pause menu.
* Per-kind colours / borders / italics in `Config.Style.kinds`.
* `/try` rolls a random outcome; formats and ranges per command in `Config.Commands`.
* Optional chat echo for accessibility; rate limited; tags stripped.

lxr-core detects this resource and disables its own native `/me` rendering
(`Config.Commands.meRenderer = 'auto'`).

The core emits `lxr:client:me(senderServerId, message)`; this resource's server
emits `lxr:me:<kind>(source, text)` for logging resources.

**Status:** syntax-checked; NUI verified in a browser; NOT TESTED in-game.

© 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved — see LICENSE.
Fonts: LXR UI Kit (Inter, Noto Sans Georgian — SIL OFL 1.1, html/fonts/OFL.txt).
