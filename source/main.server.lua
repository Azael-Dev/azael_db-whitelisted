--===== FiveM Script =========================================
--= DB - Whitelisted (API Outage)
--===== Developed By: ========================================
--= Azael Dev
--===== Website: =============================================
--= https://www.azael.dev
--===== License: =============================================
--= Copyright (C) Azael Dev - All Rights Reserved
--= You are not allowed to sell this script
--============================================================

local players = {}

MySQL.ready(function()
    local result = MySQL.query.await('SELECT identifier, connect, banned, banned_reason, remove FROM azael_dc_whitelisted')

    if result then
        for i = 1, #result do
            local row = result[i]

            players[row.identifier] = {
                connect = row.connect,
                banned = row.banned,
                banned_reason = row.banned_reason,
                remove = row.remove
            }
        end
    end
end)

local function GetPlayerIdentifier(netId)
    for _, v in ipairs(GetPlayerIdentifiers(netId)) do
        if v:match('steam:') then
            return v
        end
    end
end

local function OnPlayerConnecting(name, Kick, deferrals)
    local netId = source
    local identifier = GetPlayerIdentifier(netId)

    deferrals.defer()

    Citizen.Wait(0)

    deferrals.update(('สวัสดี %s, กำลังตรวจสอบตัวระบุของคุณ'):format(name))

    if not identifier then
        local steamKey = tonumber(GetConvar('steam_webApiKey', ''), 16)
        
        if type(steamKey) == 'number' then
            return deferrals.done('ไม่พบบัญชี Steam ของคุณ โปรดตรวจสอบแอปพลิเคชัน Steam ของคุณว่าทำงานอยู่หรือไม่?')
        else
            return deferrals.done('ไม่สามารถเข้าถึงตัวระบุ Steam ได้ เนื่องจากเซิร์ฟเวอร์นี้ไม่ได้เปิดใช้งาน Steam API')
        end
    end
    
    Citizen.Wait(0)

    local player = players[identifier]

    if not player then
        return deferrals.done(('ไม่พบตัวระบุ %s บนฐานข้อมูลของเซิร์ฟเวอร์\n'):format(identifier))
    elseif player.banned then
        return deferrals.done(('ตัวระบุ %s ถูกระงับการใช้งานถาวร (เหตุผล: %s)\n'):format(identifier, (player.banned_reason or 'ไม่ทราบ')))
    elseif player.remove then
        return deferrals.done(('ตัวระบุ %s ถูกลบออกจากฐานข้อมูลของเซิร์ฟเวอร์ เนื่องจากไม่ได้เชื่อมต่อกับเซิร์ฟเวอร์ติดต่อกันเป็นเวลานาน (เชื่อมต่อครั้งล่าสุด: %s)\n'):format(identifier, (player.connect and os.date(' %d/%m/%Y เวลา %X', player.connect) or 'ไม่ทราบ')))
    end

    deferrals.done()
end

AddEventHandler('playerConnecting', OnPlayerConnecting)
