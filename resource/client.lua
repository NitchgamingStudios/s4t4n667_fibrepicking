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
    
    if not DoesEntityExist(bale) then return false end
    
    if bale ~= closestBale then
        closestBale = bale
        balePos = GetEntityCoords(bale)
    end

    local dist = #(pos - balePos)

    if dist > config.target.distance then return false end

    ExecuteCommand(config.picking.animation)
    Wait(100)

    if config.picking.useSkillcheck then
        local success = lib.skillCheck(config.picking.skillCheck, config.picking.skillCheckKeys)
        
        if not success then
            ClearPedTasks(ped)
            
            lib.notify({
                id = 'fibreFail',
                title = locale('fail.title'),
                description = locale('fail.description'),
                showDuration = true,
                position = 'top-right',
                icon = 'fa-solid fa-wheat-awn',
                iconColor = '#8C2425'
            })
            return false
        end
    else
        lib.progressCircle({
            duration = config.picking.progressDuration,
            label = locale('progresslabel'),
            useWhileDead = false,
            canCancel = true,
            position = 'bottom',
            disable = {
                car = true,
                move = true,
            },
            anim = {
                dict = "amb@prop_human_bum_bin@idle_a",
                clip = "idle_a",
            },
        })
    end

    local picked = lib.callback.await('s4t4n667_fibrepicking:PickFibre', false, config.item)
    
    ClearPedTasks(ped)
    
    return picked
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