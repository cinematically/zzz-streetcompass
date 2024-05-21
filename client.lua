local directions = {
    [0] = 'N', [45] = 'NE', [90] = 'E', [135] = 'SE',
    [180] = 'S', [225] = 'SW', [270] = 'W', [315] = 'NW', [360] = 'N',
}

local showStreetCompass = false 

RegisterCommand('toggleStreetCompass', function()
    showStreetCompass = not showStreetCompass -- State toggle
    
    if not showStreetCompass then
        SendNUIMessage({
            action = 'clearDisplay', 
        })
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) -- Update interval
        
        if showStreetCompass then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = math.floor(GetEntityHeading(ped) + 0.5)
            local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            streetName = GetStreetNameFromHashKey(streetName)
            crossingRoad = crossingRoad and GetStreetNameFromHashKey(crossingRoad) or 'N/A'

            local nearestDegree = (math.floor((heading + 22.5) / 45) * 45) % 360
            local direction = directions[nearestDegree] or 'N'

            SendNUIMessage({
                action = 'updateLocation',
                direction = direction,
                street = streetName,
                crossing = crossingRoad,
            })
        end
    end
end)
