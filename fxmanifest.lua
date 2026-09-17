--[[
    ██╗     ██╗  ██╗██████╗       ███╗   ███╗███████╗
    ██║     ╚██╗██╔╝██╔══██╗      ████╗ ████║██╔════╝
    ██║      ╚███╔╝ ██████╔╝█████╗██╔████╔██║█████╗
    ██║      ██╔██╗ ██╔══██╗╚════╝██║╚██╔╝██║██╔══╝
    ███████╗██╔╝ ██╗██║  ██║      ██║ ╚═╝ ██║███████╗
    ╚══════╝╚═╝  ╚═╝╚═╝  ╚═╝      ╚═╝     ╚═╝╚══════╝

    🐺 LXR Core - /me, /do, /try, /whisper as NUI 3D text (Georgian OK)

    Brand:       LXRCore — Lux Empire eXperience RedM Core
    Developer:   iBoss21 / LXRCore
    Website:     https://www.lxrcore.com
    Discord:     https://discord.gg/ZHMKVYyhBa (development)
    GitHub:      https://github.com/LXRCore

    Version: 1.0.0
    Performance Target: 0.00 ms idle

    © 2026 iBoss21 / LXRCore | lxrcore.com | All Rights Reserved
]]

fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'
lua54 'yes'

name 'lxr-me'
author 'iBoss21 / LXRCore'
description 'LXRCore v3 roleplay text overlay: /me /do /try /whisper rendered as NUI 3D text with a Georgian-capable font'
version '1.0.0'
repository 'https://github.com/LXRCore/lxr-me'

shared_scripts {
    'shared/locale.lua',
    'locales/*.lua',
    'config.lua',
}

client_script 'client/main.lua'
server_script 'server/main.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/app.js',
    'html/fonts/NotoSansGeorgian-Medium.ttf',
}

dependency 'lxr-core'
