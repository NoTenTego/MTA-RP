local mysql = exports.mysql

function characterList()
	local row = mysql:query(true, "SELECT * FROM `characters` WHERE `account` = '"..getElementData(client, 'accountID').."'")
	if not row[1] then
		triggerClientEvent(client, "accounts:newCharacter", client)
		return
	end

	local charactersData = {}
	for i, value in ipairs(row) do
		table.insert(charactersData, value)
	end
	triggerClientEvent(client, "accounts:characterSelection", client, charactersData)
end
addEvent("accounts:characterList", true)
addEventHandler("accounts:characterList", root, characterList)

addEvent("accounts:createNewCharacter", true)
addEventHandler("accounts:createNewCharacter", root, function(data)
	mysql:execute(true, "INSERT INTO characters SET account='"..(getElementData(client, 'accountID') or 0).."', name='"..data[1].."', surname='"..data[2].."', description='"..data[3].."', gender='"..data[4].."', height='"..data[5].."', weight='"..data[6].."', age='"..data[7].."', skin='"..data[8].."', class='"..data[9].."'")
	characterList(getElementData(client, 'accountID'))
end)

addEvent("accounts:spawnCharacter", true)
addEventHandler("accounts:spawnCharacter", root, function(character)
	setElementData(client, "loggedIn", true)
	setCameraTarget(client)
	clearChatBox()
	
	--w zaleznosci od klasy
	setElementPosition(client, 825.32727050781, -1360.0539550781, -0.5078125)

	setElementFrozen(client, false)
	setPlayerNametagShowing(client,false)
	setPlayerName(client, character['name']..'_'..character['surname'])
	setElementInterior(client, character['interior'])
	setElementDimension(client, character['dimension'])
	setElementHealth(client, character['health'])
	setPedArmor(client, character['armor'])
	setElementModel(client, character['skin'])
	setPlayerMoney(client, character['money'])
	setElementData(client, "gender", character['gender'])
	setElementData(client, "age", character['age'])
	setElementData(client, "weight", character['weight'])
	setElementData(client, "height", character['height'])
	setElementData(client, "description", character['description'])
	setElementData(client, "characterID", character['id'])
	setElementData(client, "class", character['class'])

	--przedmioty

	local row = mysql:query(true, "SELECT * FROM `items` WHERE `owner` = '"..getElementData(client, 'characterID').."'")
	if row[1] then
		items = {}
		for i, item in pairs(row) do
			table.insert(items, {item.name, item.value_1, item.value_2, item.itemID, item.id, item.owner})
		end
		setElementData(client, "items", items)
	end

	setPlayerHudComponentVisible(client, 'all', true)
	setPlayerHudComponentVisible(client, 'wanted', false)
	setPlayerHudComponentVisible(client, 'radio', false)
	setPlayerHudComponentVisible(client, 'vehicle_name', false)
	setPlayerHudComponentVisible(client, 'clock', false)
	setPlayerHudComponentVisible(client, 'area_name', false)
end)