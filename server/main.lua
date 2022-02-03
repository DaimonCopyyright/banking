--================================================================================================
--==                     VB BANKING FOR QBUS | BY OSMIUM | discord.io/osmfx                     ==
--================================================================================================

ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('qb-banking:server:GetPlayerName', function(source, cb)
    local user = ESX.GetPlayerFromId(src)
	local firstname = Player.PlayerData.charinfo.firstname
	local lastname = Player.PlayerData.charinfo.lastname
	local charname = ''..firstname..' '..lastname..''
	print(charname)
	cb(charname)
end)

RegisterServerEvent('qb-banking:server:depositvb')
AddEventHandler('qb-banking:server:depositvb', function(amount, inMenu)
	local _src = source
	local user = ESX.GetPlayerFromId(src)
	amount = tonumber(amount)
	Citizen.Wait(50)
	if amount == nil or amount <= 0 or amount > Player.PlayerData.money['cash'] then
		TriggerClientEvent('chatMessage', _src, "BANK","normal","Invalid Quantity.")
	else
		xPlayer.removeMoney('cash', amount, 'deposit')
		xPlayer.addMoney('bank', amount, 'deposit')
		TriggerClientEvent('chatMessage', _src,"BANK","normal", "Successfully Deposited $"..amount)
	end
end)

RegisterServerEvent('qb-banking:server:withdrawvb')
AddEventHandler('qb-banking:server:withdrawvb', function(amount, inMenu)
	local _src = source
	local user = ESX.GetPlayerFromId(src)
	local _base = 0
	amount = tonumber(amount)
	_base = Player.PlayerData.money['bank']
	Citizen.Wait(100)
	if amount == nil or amount <= 0 or amount > _base then
		TriggerClientEvent('chatMessage', _src, "Invalid Quantity")
	else
		xPlayer.removeMoney('bank', amount, 'withdraw')
		xPlayer.addMoney('cash', amount, 'withdraw')
		TriggerClientEvent('chatMessage', _src, "BANK","normal","Successfully Withdrew $"..amount.."")
	end
end)

RegisterServerEvent('qb-banking:server:balance')
AddEventHandler('qb-banking:server:balance', function(inMenu)
	local _src = source
	local user = ESX.GetPlayerFromId(src)
	local balance = Player.PlayerData.money['bank']
	TriggerClientEvent('qb-banking:client:refreshbalance', _src, balance)
end)

RegisterServerEvent('qb-banking:server:transfervb')
AddEventHandler('qb-banking:server:transfervb', function(to, amount2, inMenu)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(src)
	local zPlayer =  ESX.GetPlayerFromId(tonumber(to))
	local balance = 0
	if zPlayer ~= nil then
		balance = xPlayer.getAccount('bank').money
		if tonumber(_source) == tonumber(to) then
			TriggerClientEvent('chatMessage', _source, "BANK","normal","You can't transfer money to yourself")	
		else
			if balance <= 0 or balance < tonumber(amount2) or tonumber(amount2) <= 0 then
				TriggerClientEvent('chatMessage', _source,"BANK","normal", "You don't have enough money in your bank account.")
			else
				xPlayer.removeMoney('bank', amount2, 'withdraw')
				xPlayer.AddMoney('bank', amount2, 'withdraw')
				TriggerClientEvent('chatMessage', _source, "BANK","normal","Transferred $"..amount2.." to ID "..tonumber(to)..".")
				TriggerClientEvent('chatMessage', tonumber(to), "BANK","normal","Received $"..amount2.." from ID "..source..".")
			end
		end
	else
		TriggerClientEvent('chatMessage', _source, "That Wallet ID is not valid or doesn't exist")
	end
end)