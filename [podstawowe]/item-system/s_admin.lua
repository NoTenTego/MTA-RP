local mysql = exports.mysql

addEvent('item-system:getItems', true)
addEventHandler('item-system:getItems', root, function(thePlayer)
    local items = {}

    local query = mysql:query(true, 'SELECT id, name, itemID, value_1, value_2 FROM itemlist')
    if query[1] then
        for i, item in pairs(query) do
            table.insert(items, {item['name'], item['itemID'], item['value_1'], item['value_2'], item['id']})
        end
    end

    triggerClientEvent(thePlayer, 'item-system:openItemList', thePlayer, items)
end)

addEvent('item-system:makeItem', true)
addEventHandler('item-system:makeItem', root, function(name, itemID, value1, value2)
    mysql:execute(true, "INSERT INTO itemlist SET name='"..name.."', itemID='"..itemID.."', value_1='"..value1.."', value_2='"..value2.."', createdBy='"..getElementData(client, 'username').."'")
    triggerClientEvent(client, 'hud:sendNotification', client, 'Pomyślnie dodano przedmiot do listy przedmiotów.')
end)

addEvent('item-system:saveItem', true)
addEventHandler('item-system:saveItem', root, function(name, itemID, value1, value2, dbid)
    mysql:execute(true, "UPDATE itemlist SET name='"..name.."', itemID='"..itemID.."', value_1='"..value1.."', value_2='"..value2.."' WHERE id = '"..dbid.."'")
    triggerClientEvent(client, 'hud:sendNotification', client, 'Pomyślnie zaktualizowani przedmiot na liście. Wszystkie stare przedmioty zachowają swoje stare właściwości.')
end)

addEvent('item-system:deleteItem', true)
addEventHandler('item-system:deleteItem', root, function(dbid)
    mysql:execute(true, "DELETE FROM itemlist WHERE id = '"..dbid.."'")
    triggerClientEvent(client, 'hud:sendNotification', client, 'Pomyślnie usunięto przedmiot z listy. Gracze dalej będą mogli używać przedmiotów ze starymi właściwościami.')
end)