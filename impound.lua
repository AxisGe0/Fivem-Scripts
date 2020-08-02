ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

RegisterNetEvent('gcrp:impound')
AddEventHandler('gcrp:impound', function()
    local playerPed = PlayerPedId()
    local vehicle   = ESX.Game.GetVehicleInDirection()

    if IsPedInAnyVehicle(playerPed, true) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    end

    if DoesEntityExist(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
    end
end)

RegisterCommand('imp', function(source, args)
    if ESX.PlayerData.job.name == 'police' or  PlayerData.job.name == 'ambulance' or PlayerData.job.name == 'offpolice' or PlayerData.job.name == 'offambulance'  then
        local impound = 'Towing Vehicle'
        local ped = PlayerPedId()
        local imp = 'Vehicle Siezed'
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            exports['mythic_notify']:SendAlert('inform', 'You Must Be OutSide Of The Vehicle')
        else 
            exports['progressBars']:startUI(7000, "Towing Vehicle")
            TaskStartScenarioInPlace(ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            TriggerEvent('3dme:triggerDisplay',impound , source)
            Citizen.Wait(7000)
            TriggerEvent('3dme:triggerDisplay',imp , source)
            TriggerEvent('gcrp:impound', source)
            ClearPedTasksImmediately(ped)
        end
    end
end,false)