--[[
    ██╗     ██╗  ██╗██████╗       ███╗   ███╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ████╗ ████║██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██╔████╔██║█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║╚██╔╝██║██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ██║ ╚═╝ ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝╚══════╝

    🐺 LXR Core - /me & /do as NUI 3D text

    RDR3's native text cannot draw Georgian (boxes). lxr-me listens to the
    core's `lxr:client:me` event (and the legacy name), projects the speaker's
    head to the screen every frame and draws the line through a NUI overlay
    with a bundled Georgian-capable font. The draw loop only runs while a line
    is on screen — 0.00 ms otherwise. Adds /do, /try and /whisper variants.

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Product:     wolves.land / The Land of Wolves 🐺
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/GAhk8cgXe9
    GitHub:      https://github.com/LXRCore

    Version: 1.0.0
    Performance Target: 0.00 ms idle

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

Config = Config or {}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ LANGUAGE ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Lang = 'en' -- any file in locales/

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ DISPLAY ███████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Display = {
    durationMs   = 8000,     -- how long a line floats (per-command override below)
    distance     = 20.0,     -- max distance to see another player's line (server also filters by core meRange)
    zOffset      = 1.05,     -- height above the ped origin (metres)
    maxOnScreen  = 12,       -- cap on simultaneous lines
    stack        = true,     -- several lines from the same player stack upward instead of overlapping
    stackGapPx   = 22,
    fadeMs       = 400,      -- fade-in / fade-out
    minScale     = 0.55,     -- scale at `distance`
    maxChars     = 160,      -- longer messages are cut (the core already limits chat length)
    hideWhenPaused = true,
}

-- Visual style per kind — LXR UI Kit tokens only (inks + the single blood accent;
-- green/amber are status semantics). Fonts are the kit's: Inter for Latin,
-- Noto Sans Georgian for Mkhedruli. No other hue is allowed.
Config.Style = {
    font       = "'LXR Plain', 'LXR Ka', Inter, 'Segoe UI', 'Sylfaen', sans-serif",
    fontSizePx = 14,
    radiusPx   = 0,
    shadow     = true,
    kinds = {
        me      = { prefix = '',   italic = true },
        ["do"]  = { prefix = '',   italic = false },
        try     = { prefix = '',   italic = true },
        whisper = { prefix = '',   italic = true },
    },
}

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ COMMANDS ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
-- /me comes from lxr-core (Config.Commands.meRange). These extra commands are
-- registered here through the native command API and use the same overlay.
Config.Commands = {
    ["do"]   = { enabled = true, range = 12.0, durationMs = 8000,  showName = false, format = '(( %{message} ))' },
    try      = { enabled = true, range = 12.0, durationMs = 8000,  showName = false, format = '%{message} — %{result}', results = { 'success', 'failure' } },
    whisper  = { enabled = true, range = 3.0,  durationMs = 6000,  showName = false, format = '%{message}' },
}
Config.ShowNameOnMe = false   -- prefix the character's name to /me lines (e.g. "Sadie Adler smiles")
Config.ChatEcho     = true    -- also echo lines to the chat box of players in range (accessibility)

-- ████████████████████████████████████████████████████████████████████████████████
-- ████████████████████████ SECURITY ██████████████████████████████████████████████
-- ████████████████████████████████████████████████████████████████████████████████
Config.Security = {
    rateLimit = { burst = 6, windowMs = 10000 },  -- per player, across all commands
    stripTags = true,                             -- remove < > and ~ colour codes from messages
}

Config.Debug = false
