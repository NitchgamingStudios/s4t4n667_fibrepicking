lib.locale()
local config = require('config')

local model = 1395331371 -- prop_haybale_03

local closestBale, balePos


CreateThread(function()
    if config.blip.enabled then
        local fibresBlip = AddBlipForCoord(config.blip.coords.x, config.blip.coords.y, config.blip.coords.z)
        SetBlipSprite(fibresBlip, config.blip.sprite)
        SetBlipColour(fibresBlip, config.blip.spriteColor)
        SetBlipScale(fibresBlip, config.blip.scale)
        SetBlipAsShortRange(fibresBlip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(config.blip.label)
        EndTextCommandSetBlipName(fibresBlip)
    end
end)


local function pickFibres()
    local ped = PlayerPedId()
    local pos = GetEntityCoords(ped)

    local bale = GetClosestObjectOfType(pos.x, pos.y, pos.z, config.target.distance, model, false, false, false)
    if DoesEntityExist(bale) then
        if bale ~= closestBale then
            closestBale = bale
            balePos = GetEntityCoords(bale)
        end

        local dist = #(pos - balePos)

        if dist <= config.target.distance then
            ExecuteCommand(config.animation)
            Wait(100)

            local success = lib.skillCheck(config.skillCheck, { 'e', 'e', 'e' })

            if not success then
                ClearPedTasks(PlayerPedId())
                
                lib.notify({
                    id = 'fibreFail',
                    title = locale('fail.title'),
                    description = locale('fail.description'),
                    showDuration = true,
                    position = 'top-right',
                    icon = 'fa-solid fa-wheat-awn',
                    iconColor = '#8C2425'
                })
                return
            end

            local picked = lib.callback.await('s4t4n667_fibrepicking:PickFibre', false, config.item)
            
            ClearPedTasks(PlayerPedId())
            return picked
        else
            return false
        end
    end
end


local function fibreSpots()
    local options = {
        {
            name = 'fibrePicking',
            label = config.target.label,
            icon = config.target.icon,
            iconColor = config.target.iconColor,
            distance = config.target.distance,
            onSelect = function()
                pickFibres()
            end,
        },
    }
    exports.ox_target:addModel(model, options)
end


RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    fibreSpots()
end)

RegisterNetEvent('esx:playerLoaded', function()
    fibreSpots()
end)

AddEventHandler('onResourceStart', function(resource)
    fibreSpots()
end)