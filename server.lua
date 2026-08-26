local ESX = nil
local QBCore = nil

if Config.UseESX then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.UseQBCore then
    QBCore = exports['qb-core']:GetCoreObject()
end

local searchableItems = {}
for _, itemName in ipairs(Config.SearchableItems) do
    searchableItems[itemName] = true
end

local function itemListHasSearchableItem(items)
    if type(items) ~= 'table' then return false end

    for _, item in pairs(items) do
        if item and item.name and searchableItems[item.name] then
            return true
        end
    end

    return false
end

if Config.UseESX then
    ESX.RegisterServerCallback('angelicxs-k9script:server:search:ESX', function(source, cb, target)
        local xPlayer = ESX.GetPlayerFromId(tonumber(target))
        if not xPlayer then
            cb(false)
            return
        end

        for _, itemName in ipairs(Config.SearchableItems) do
            local item = xPlayer.getInventoryItem(itemName)
            if item and item.count and item.count > 0 then
                cb(true)
                return
            end
        end

        cb(false)
    end)

    ESX.RegisterServerCallback('angelicxs-k9script:server:searchcar:ESX', function(source, cb, plate)
        if type(plate) ~= 'string' or plate == '' then
            cb(false)
            return
        end

        MySQL.Async.fetchAll('SELECT glovebox, trunk FROM owned_vehicles WHERE plate = ?', { plate }, function(result)
            if not result or not result[1] then
                cb(false)
                return
            end

            local glovebox = result[1].glovebox and json.decode(result[1].glovebox) or {}
            local trunk = result[1].trunk and json.decode(result[1].trunk) or {}
            cb(itemListHasSearchableItem(glovebox) or itemListHasSearchableItem(trunk))
        end)
    end)
elseif Config.UseQBCore then
    QBCore.Functions.CreateCallback('angelicxs-k9script:server:search:QBCore', function(source, cb, target)
        local player = QBCore.Functions.GetPlayer(tonumber(target))
        if not player or not player.PlayerData then
            cb(false)
            return
        end

        cb(itemListHasSearchableItem(player.PlayerData.items))
    end)

    QBCore.Functions.CreateCallback('angelicxs-k9script:server:searchcar:QBCore', function(source, cb, plate)
        if type(plate) ~= 'string' or plate == '' then
            cb(false)
            return
        end

        local gloveboxFound = getOwnedVehicleGloveboxItems(plate)
        local trunkFound = not gloveboxFound and getOwnedVehicleItems(plate)
        cb(gloveboxFound or trunkFound)
    end)

    function getOwnedVehicleGloveboxItems(plate)
        local result = exports['qb-inventory']:getGloveboxItems(plate)
        return result and itemListHasSearchableItem(result.items) or false
    end

    function getOwnedVehicleItems(plate)
        local result = exports['qb-inventory']:getTrunkItems(plate)
        return result and itemListHasSearchableItem(result.items) or false
    end
end
