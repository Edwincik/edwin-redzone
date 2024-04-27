local isMeldingVerstuurd = false
local leaveMessage = 5000
local isLeaveMessagePresent = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        local ped = GetEntityCoords(GetPlayerPed(-1))

        for _, zoneData in pairs(Config.Redzones) do
            local playercoords = GetEntityCoords(PlayerPedId())

            if GetDistanceBetweenCoords(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, playercoords, false) < 250 then
                DrawMarker(28, zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, zoneData.Radius, zoneData.Radius, zoneData.Radius, 255, 0, 0, 40, false, true, 2, nil, nil, false)
            end

            local distanceToZone = Vdist(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z, ped)

            if distanceToZone < zoneData.Radius then
                if not isMeldingVerstuurd then
                    Wait(0)
                    isMeldingVerstuurd = true
                    EnteredRedzone()
                end
            elseif distanceToZone < (zoneData.Radius + 30) and distanceToZone > zoneData.Radius then
                if isLeaveMessagePresent then
                end

                if isMeldingVerstuurd then
                    LeftRedzone()
                end

                isMeldingVerstuurd = false
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, zoneData in pairs(Config.Redzones) do
        local blip = AddBlipForCoord(zoneData.Coords.x, zoneData.Coords.y, zoneData.Coords.z)
        
        SetBlipSprite(blip, 429)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, zoneData.BlipColour)
        SetBlipAsShortRange(blip, true)

        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(zoneData.BlipName)
    end
end)

function EnteredRedzone()
    TriggerEvent("QBCore:Notify", "Redzone'a girdin.", "success")
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)
    isLeaveMessagePresent = true
end

function LeftRedzone()
    TriggerEvent("QBCore:Notify", "Redzone'dan ayrıldın.", "error")
    PlaySound(-1, "CHARACTER_CHANGE_CHARACTER_01_MASTER", 0, 0, 0, 0)

    Citizen.SetTimeout(leaveMessage, function()
        isLeaveMessagePresent = false
    end)
end

function DrawTextOnScreen(text, x, y, r, g, b, a, s, font)
    SetTextColour(r, g, b, a)
    SetTextFont(font)
    SetTextScale(s, s)
    SetTextCentre(false)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

