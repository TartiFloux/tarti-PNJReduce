-- Etat debug
debugZones = false

-- Exemple de zones
local Zones = {
    {
        name = "Centre-ville",
        coords = vector3(215.76, -810.12, 30.73),
        radius = 400.0,
        pedDensity = 0.0,
        vehicleDensity = 0.1,
        randomVehicleDensity = 0.1,
        parkedVehicleDensity = 0.0,
        scenarioPedDensity = 0.0
    },
    {
        name = "Quartier Gang",
        coords = vector3(128.21, -1695.10, 38.08),
        radius = 500.0,
        pedDensity = 0.0,
        vehicleDensity = 0.0,
        randomVehicleDensity = 0.0,
        parkedVehicleDensity = 0.0,
        scenarioPedDensity = 0.0
    },
    {
        name = "Plage",
        coords = vector3(-1143.30, -1558.14, 11.09),
        radius = 200.0,
        pedDensity = 0.3,
        vehicleDensity = 0.1,
        randomVehicleDensity = 0.1,
        parkedVehicleDensity = 0.0,
        scenarioPedDensity = 0.0
    },
    {
        name = "Vinewood",
        coords = vector3(359.56, 135.72, 103.09),
        radius = 200.0,
        pedDensity = 0.3,
        vehicleDensity = 0.1,
        randomVehicleDensity = 0.1,
        parkedVehicleDensity = 0.0,
        scenarioPedDensity = 0.0
    },

    {
        name = "Plage2",
        coords = vector3(-1257.69, -1122.33, 17.63),
        radius = 270.0,
        pedDensity = 0.3,
        vehicleDensity = 0.3,
        randomVehicleDensity = 0.3,
        parkedVehicleDensity = 0.0,
        scenarioPedDensity = 0.0
    }
}

local DefaultDensity = {
    ped = 0.0,
    vehicle = 0.0,
    randomVehicle = 0.0,
    parkedVehicle = 0.0,
    scenarioPed = 0.0
}

-- Thread densité PNJ/voiture
CreateThread(function()
    while true do
        Wait(0)
        local coords = GetEntityCoords(PlayerPedId())
        local applied = false

        for _, zone in pairs(Zones) do
            if #(coords - zone.coords) <= zone.radius then
                SetPedDensityMultiplierThisFrame(zone.pedDensity)
                SetVehicleDensityMultiplierThisFrame(zone.vehicleDensity)
                SetRandomVehicleDensityMultiplierThisFrame(zone.randomVehicleDensity)
                SetParkedVehicleDensityMultiplierThisFrame(zone.parkedVehicleDensity)
                SetScenarioPedDensityMultiplierThisFrame(zone.scenarioPedDensity, zone.scenarioPedDensity)
                applied = true
                break
            end
        end

        if not applied then
            SetPedDensityMultiplierThisFrame(DefaultDensity.ped)
            SetVehicleDensityMultiplierThisFrame(DefaultDensity.vehicle)
            SetRandomVehicleDensityMultiplierThisFrame(DefaultDensity.randomVehicle)
            SetParkedVehicleDensityMultiplierThisFrame(DefaultDensity.parkedVehicle)
            SetScenarioPedDensityMultiplierThisFrame(DefaultDensity.scenarioPed, DefaultDensity.scenarioPed)
        end
    end
end)

-- Thread debug visuel
CreateThread(function()
    while true do
        if not debugZones then
            Wait(500)
        else
            Wait(0)
            local playerCoords = GetEntityCoords(PlayerPedId())

            for _, zone in pairs(Zones) do
                local distance = #(playerCoords - zone.coords)
                local inZone = distance <= zone.radius
                local r, g, b = inZone and 0 or 255, inZone and 255 or 0, 0

                -- Sphere
                DrawMarker(28, zone.coords.x, zone.coords.y, zone.coords.z, 0,0,0,0,0,0, zone.radius, zone.radius, zone.radius, r, g, b, 80, false, false, 2, false, nil, nil, false)
                -- Centre
                DrawMarker(2, zone.coords.x, zone.coords.y, zone.coords.z + 1.0, 0,0,0,0,0,0, 0.6,0.6,0.6, 255,255,255,200, false,false,2,false,nil,nil,false)
            end
        end
    end
end)

-- Event pour toggle debug depuis serveur
RegisterNetEvent("PNJReduce:toggleDebug")
AddEventHandler("PNJReduce:toggleDebug", function()
    debugZones = not debugZones
    TriggerEvent("chat:addMessage", {
        color = {0, 255, 0},
        args = {"Zones", "Debug visuel : " .. (debugZones and "ON" or "OFF")}
    })
end)
