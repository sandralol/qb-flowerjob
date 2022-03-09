local QBCore = exports['qb-core']:GetCoreObject()

local itemcraft = 'markedbills'

RegisterServerEvent('qb-flowerjob:pickedUpflower', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    TriggerClientEvent("QBCore:Notify", src, "Picked up some flower!!", "Success", 1000)
    Player.Functions.AddItem('rose_flower', 1) ---- change this shit 
    TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['rose_flower'], "add")
end)

RegisterServerEvent('qb-flowerjob:processflower', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local flower = Player.Functions.GetItemByName("rose_flower")
      local flower_paper = Player.Functions.GetItemByName("flower_paper")

    if flower ~= nil and flower_paper ~= nil then
        if Player.Functions.RemoveItem('rose_flower', 3) and Player.Functions.RemoveItem('flower_paper', 1) then
            Player.Functions.AddItem('rose_bukey', 1)-----change this
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['rose_flower'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['flower_paper'], "remove")
            TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['rose_bukey'], "add")
            TriggerClientEvent('QBCore:Notify', src, 'Flowers Processed successfully', "success")  
        else
            TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
        end
    else
        TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
    end
end)

--selldrug ok

RegisterServerEvent('qb-flowerjob:selld', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	local Item = Player.Functions.GetItemByName('rose_bukey')
   
	if Item ~= nil and Item.amount >= 1 then
		local chance2 = math.random(1, 12)
		if chance2 == 1 or chance2 == 2 or chance2 == 9 or chance2 == 4 or chance2 == 10 or chance2 == 6 or chance2 == 7 or chance2 == 8 then
			Player.Functions.RemoveItem('rose_bukey', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['rose_bukey'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'you sold to the pusher', "success")  
		else
			Player.Functions.RemoveItem('rose_bukey', 1)----change this
			TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['rose_bukey'], "remove")
			Player.Functions.AddMoney("cash", Config.Pricesell-100, "sold-pawn-items")
			TriggerClientEvent('QBCore:Notify', src, 'you sold the flowers to the gardener', "success")
		end
else
	TriggerClientEvent('QBCore:Notify', src, 'You don\'t have the right items', "error") 
	
end
end)

function CancelProcessing(playerId)
	if playersProcessingflower[playerId] then
		ClearTimeout(playersProcessingflower[playerId])
		playersProcessingflower[playerId] = nil
	end
end

RegisterServerEvent('qb-flowerjob:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('QBCore_:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('qb-flowerjob:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)

QBCore.Functions.CreateCallback('poppy:process', function(source, cb)
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)
	 
	if Player.PlayerData.items ~= nil and next(Player.PlayerData.items) ~= nil then
		for k, v in pairs(Player.PlayerData.items) do
		    if Player.Playerdata.items[k] ~= nil then
				if Player.Playerdata.items[k].name == "rose_flower" then
					cb(true)
			    else
					TriggerClientEvent("QBCore:Notify", src, "You do not have any Flowers", "error", 10000)
					cb(false)
				end
	        end
		end	
	end
end)
