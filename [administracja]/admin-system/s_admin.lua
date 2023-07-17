local mysql = exports.mysql

addCommandHandler('itemlist', function(thePlayer)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'itemlist') then
        return
    end

    triggerEvent('item-system:getItems', thePlayer, thePlayer)
end)

addCommandHandler('vehlib', function(thePlayer)
    if not exports.global:hasPermission(thePlayer, 'vehicle-system', 'vehlib') then
        return
    end

    triggerEvent('vehicle-system:getVehlibData', thePlayer, thePlayer)
end)

addCommandHandler('createitem', function(thePlayer, commandName, targetPlayer, itemID, value1, value2, ...)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'createitem') then
        return
    end

	local name = table.concat({...}, " ")
	if not itemID or not value1 or not value2 or not name or not targetPlayer then return
		triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, "Przykład: /createitem [ID/dane osobowe odbiorcy] [itemID] [value1] [ilość] [name]")
	end
	
	targetPlayer = exports.global:findPlayer(targetPlayer)
	if not targetPlayer then
		triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'Nie znaleziono gracza o podanych danych')
		return
	end

    local result, affectedRows, lastInsertedID = mysql:query(true, "INSERT INTO items SET owner='"..getElementData(targetPlayer, 'characterID').."', itemID='"..itemID.."', value_1='"..value1.."', value_2='"..value2.."', name='"..name.."'")
	triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, "Pomyślnie stworzono nowy unikalny przedmiot ["..name.."] Wartość 1: ["..value1.."] Wartość 2: ["..value2.."] ID: ["..lastInsertedID.."]")
	triggerClientEvent(targetPlayer, "hud:sendNotification", targetPlayer, "Administrator "..getElementData(thePlayer, "username").." stworzył Ci unikalny przedmiot o nazwie ["..name.."]. Sprawdź ekwipunek.")

	local items = getElementData(targetPlayer, "items")
	if not items then
		items = {}
	end

	local itemReplaced = false
	for i, item in pairs(items) do
		if (item[1] == name) and (item[2] == value1) and (item[4] == itemID) then
			item[3] = item[3] + value2
			mysql:execute(true, 'UPDATE items SET value_2='..item[3]..' WHERE id = '..item[5]..'')
			itemReplaced = true
			break
		end
	end

	if not itemReplaced then
		table.insert(items, {name, value1, value2, itemID, lastInsertedID, getElementData(targetPlayer, 'characterID')})
	end
	setElementData(targetPlayer, "items", items)
end)

addCommandHandler('giveitem', function(thePlayer, commandName, targetPlayer, dbid, amount)
    if not exports.global:hasPermission(thePlayer, 'admin-system', 'giveitem') then
        return
    end

	amount = tonumber(amount)

	if not dbid or not targetPlayer or not amount then return
		triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, "Przykład: /giveitem [ID/dane osobowe odbiorcy] [DBID z /itemlist] [ilość]")
	end
	
	targetPlayer = exports.global:findPlayer(targetPlayer)
	if not targetPlayer then
		triggerClientEvent(thePlayer, "hud:sendNotification", thePlayer, 'Nie znaleziono gracza o podanych danych')
		return
	end

	local query = mysql:query(true, 'SELECT name, value_1, itemID FROM itemlist WHERE id='..dbid..'')
	if not query[1] then
		return
	end

	local items = getElementData(targetPlayer, "items")
	if not items then
		items = {}
	end

	local itemReplaced = false
	for i, item in pairs(items) do
		if (item[1] == query[1]['name']) and (item[2] == query[1]['value_1']) and (item[4] == query[1]['itemID']) then
			item[3] = item[3] + amount
			mysql:execute(true, 'UPDATE items SET value_2='..item[3]..' WHERE id = '..item[5]..'')
			itemReplaced = true
			break
		end
	end

	if not itemReplaced then
		table.insert(items, {query[1]['name'], query[1]['value_1'], amount, query[1]['itemID'], dbid, getElementData(targetPlayer, 'characterID')})
		mysql:execute(true, "INSERT INTO items SET owner='"..getElementData(targetPlayer, 'characterID').."', itemID='"..query[1]['itemID'].."', value_1='"..query[1]['value_1'].."', value_2='"..amount.."', name='"..query[1]['name'].."'")
	end
	setElementData(targetPlayer, "items", items)
end)