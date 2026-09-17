--[[ ═══════════════════════════════════════════════════════════════════════════
     🐺 LXR-ME — Client: project heads to screen, draw through NUI
     ═══════════════════════════════════════════════════════════════════════════
     The core's /me arrives as `lxr:client:me(senderServerId, message)`; the
     core skips its native 3D text while this resource is started
     (Config.Commands.meRenderer). /do /try /whisper arrive from this
     resource's server. One frame-loop runs only while lines are active.
     ═══════════════════════════════════════════════════════════════════════════
     © 2026 iBoss21 / LXRCore — All Rights Reserved
     ═══════════════════════════════════════════════════════════════════════════ ]]

local LXRCore = exports['lxr-core']:GetCoreObject()
local D = Config.Display

local active = {}   -- id → { player, kind, text, expires, born }
local running = false
local nextId = 0

local function count() local n = 0 for _ in pairs(active) do n = n + 1 end return n end

local function loop()
    if running then return end
    running = true
    SendNUIMessage({ action = 'style', style = Config.Style, display = { fadeMs = D.fadeMs, stackGapPx = D.stackGapPx } })
    CreateThread(function()
        while next(active) do
            local now = GetGameTimer()
            local myPed = PlayerPedId()
            local me = GetEntityCoords(myPed)
            local paused = D.hideWhenPaused and IsPauseMenuActive()
            local items, n = {}, 0
            local perPlayer = {}
            for id, e in pairs(active) do
                if now > e.expires then
                    active[id] = nil
                else
                    local ped = e.player == PlayerId() and myPed or GetPlayerPed(e.player)
                    if not paused and ped ~= 0 and DoesEntityExist(ped) then
                        local c = GetEntityCoords(ped)
                        local dist = #(me - c)
                        if dist <= D.distance then
                            local onScreen, sx, sy = GetScreenCoordFromWorldCoord(c.x, c.y, c.z + D.zOffset)
                            if onScreen then
                                local stack = 0
                                if D.stack then
                                    stack = perPlayer[e.player] or 0
                                    perPlayer[e.player] = stack + 1
                                end
                                n = n + 1
                                items[n] = {
                                    id = id, x = sx, y = sy, text = e.text, kind = e.kind, stack = stack,
                                    scale = math.max(D.minScale, 1.0 - dist / D.distance * (1.0 - D.minScale)),
                                    dying = (e.expires - now) < D.fadeMs,
                                }
                            end
                        end
                    end
                end
            end
            SendNUIMessage({ action = 'draw', items = items })
            Wait(0)
        end
        SendNUIMessage({ action = 'draw', items = {} })
        running = false
    end)
end

local function show(senderServerId, kind, text, durationMs)
    local player = GetPlayerFromServerId(senderServerId)
    if player == -1 then return end
    local ped = player == PlayerId() and PlayerPedId() or GetPlayerPed(player)
    if ped == 0 or not DoesEntityExist(ped) then return end
    if #(GetEntityCoords(ped) - GetEntityCoords(PlayerPedId())) > D.distance then return end
    if count() >= D.maxOnScreen then return end
    nextId = nextId + 1
    -- newest line from the same player replaces its oldest when stacking is off
    if not D.stack then
        for id, e in pairs(active) do if e.player == player then active[id] = nil end end
    end
    active['m' .. nextId] = { player = player, kind = kind, text = tostring(text), expires = GetGameTimer() + (durationMs or D.durationMs), born = GetGameTimer() }
    loop()
end

RegisterNetEvent('lxr:client:me', function(senderId, msg)
    if Config.ShowNameOnMe then
        local player = GetPlayerFromServerId(senderId)
        local name = player ~= -1 and GetPlayerName(player) or ''
        msg = name .. ' ' .. tostring(msg)
    end
    show(senderId, 'me', msg, D.durationMs)
end)
RegisterNetEvent('lxr-me:client:show', function(senderId, kind, text, durationMs) show(senderId, kind, text, durationMs) end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then active = {} SendNUIMessage({ action = 'draw', items = {} }) end
end)
