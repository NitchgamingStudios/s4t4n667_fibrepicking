lib.locale()
local config = lib.require('config')
lib.versionCheck('s4t4n667/s4t4n667_fibrepicking')


lib.callback.register('s4t4n667_fibrepicking:PickFibre', function(source)

    local item = config.item
    local count = math.random(config.picking.minAmount, config.picking.maxAmount)

    if exports.ox_inventory:CanCarryItem(source, item, count) then
        exports.ox_inventory:AddItem(source, item, count)
        return true
    else
        lib.notify(source,{
            title = locale('carry.title'),
            description = locale('carry.description'),
            icon = 'fa-solid fa-wheat-awn',
            iconColor = '#8C2425',
        })
        return false
    end
end)