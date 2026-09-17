--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-ME — Server: /do /try /whisper through the core's command API
     ═══════════════════════════════════════════════════════════════════════════
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local LXR = exports['lxr-core']:GetLXR()

local buckets = {}
local function limited(src)
    local b = buckets[src]
    local now = GetGameTimer()
    if not b or now - b.at > Config.Security.rateLimit.windowMs then b = { at = now, n = 0 } buckets[src] = b end
    b.n = b.n + 1
    return b.n > Config.Security.rateLimit.burst
end

local function clean(msg)
    msg = tostring(msg or '')
    if Config.Security.stripTags then msg = msg:gsub('[<>]', ''):gsub('~[%w_]+~', '') end
    if #msg > Config.Display.maxChars then msg = msg:sub(1, Config.Display.maxChars) end
    return msg
end

local function broadcast(src, kind, text, range, durationMs)
    local coords = GetEntityCoords(GetPlayerPed(src))
    for id in pairs(LXRCore.Players) do
        local ped = GetPlayerPed(id)
        if ped ~= 0 and #(GetEntityCoords(ped) - coords) <= range then
            TriggerClientEvent('lxr-me:client:show', id, src, kind, text, durationMs)
            if Config.ChatEcho then
                TriggerClientEvent('chat:addMessage', id, { color = { 196, 165, 116 }, args = { ('/%s'):format(kind), text } })
            end
        end
    end
end

local function register(kind, def)
    LXR.Commands.Register({
        name = kind, help = Lang:t('command.' .. kind), permission = 'user',
        args = { { name = 'message', help = Lang:t('command.message') } },
        handler = function(src, args)
            if limited(src) then return LXRCore.Notify(src, Lang:t('error.rate'), 'error') end
            local message = clean(table.concat(args, ' '))
            if message == '' then return LXRCore.Notify(src, Lang:t('error.empty'), 'error') end
            local vars = { message = message }
            if def.results then
                vars.result = Lang:t('try.' .. def.results[math.random(#def.results)])
            end
            local text = (def.format or '%{message}'):gsub('%%{([%w_]+)}', function(k) return vars[k] or '' end)
            if def.showName then
                local P = LXRCore.Functions.GetPlayer(src)
                if P then text = P.PlayerData.charinfo.firstname .. ' ' .. P.PlayerData.charinfo.lastname .. ' ' .. text end
            end
            broadcast(src, kind, text, def.range or 12.0, def.durationMs)
            LXRCore.Emit('lxr:me:' .. kind, {}, src, text)
        end,
    })
end

for kind, def in pairs(Config.Commands) do
    if def.enabled then register(kind, def) end
end

AddEventHandler('playerDropped', function() buckets[source] = nil end)
