local directions = {
    [0] = 'N', [45] = 'NE', [90] = 'E', [135] = 'SE',
    [180] = 'S', [225] = 'SW', [270] = 'W', [315] = 'NW', [360] = 'N',
}

local showstreetCompass = false -- Initialize the toggle state

RegisterCommand('togglestreetcompass', function()
    showstreetCompass = not showstreetCompass -- Toggle the streetCompass state
    
    if not showstreetCompass then
        -- Clear the UI when the streetCompass is turned off, using the updated action name
        SendNUIMessage({
            action = 'clearDisplay', -- Updated to match the JavaScript listener
        })
    end
end, false)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500) -- Update interval
        
        if showstreetCompass then
            local ped = PlayerPedId()
            local coords = GetEntityCoords(ped)
            local heading = math.floor(GetEntityHeading(ped) + 0.5)
            local streetName, crossingRoad = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
            streetName = GetStreetNameFromHashKey(streetName)
            crossingRoad = crossingRoad and GetStreetNameFromHashKey(crossingRoad) or 'N/A'

            local nearestDegree = heading - (heading % 45)
            local direction = directions[nearestDegree] or 'N'

            -- Update the UI with the current location, using the action name consistent with JavaScript
            SendNUIMessage({
                action = 'updateLocation',
                direction = direction,
                street = streetName,
                crossing = crossingRoad,
            })
        end
    end
end)