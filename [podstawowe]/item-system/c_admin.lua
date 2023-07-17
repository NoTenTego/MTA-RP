loadstring(exports.dgs:dgsImportFunction())()
local sx, sy = guiGetScreenSize()
local px, py = (sx/1920), (sy/1080)
local zoom = 1
local fh = 1920
if sx < fh then
    zoom = math.min(2,fh/sx)
end

local font = dxCreateFont ( ":hud/karla.ttf" , 10)

local tab = {
    window = {},
    gridlist = {},
    column = {},
    button = {},
    edit = {},
}

function refreshData(items)
    dgsGridListClear(tab.gridlist[1])
    for i, item in pairs(items) do
        local row = dgsGridListAddRow(tab.gridlist[1])
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[1], tostring(item[5]), false, false)
        dgsGridListSetItemColor(tab.gridlist[1], row, tab.column[1], tocolor(150, 150, 150, 255))

        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[2], tostring(item[1]), false, false)
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[3], tostring(item[2]), false, false)
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[4], tostring(item[3]), false, false)
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[5], tostring(item[4]), false, false)
    end
end

addEvent('item-system:openItemList', true)
addEventHandler('item-system:openItemList', root, function(itemlist)
    if isElement(tab.window[1]) then
        return
    end
    --
    items = itemlist
    addEventHandler('onDgsMouseClick', root, buttonFunctions)
    addEventHandler('onDgsGridListSelect', root, gridListSelection)
    showCursor(true)

    tab.window[1] = dgsCreateWindow(1/zoom, 1*py, 1000/zoom, 800*py, 'Zarządzanie przedmiotami', false)
    dgsCenterElement(tab.window[1])
    dgsWindowSetSizable(tab.window[1], false)

    tab.gridlist[1] = dgsCreateGridList(10/zoom, 5*py, 980/zoom, 700*py, false, tab.window[1])
    tab.column[1] = dgsGridListAddColumn(tab.gridlist[1], 'DBID', 0.1)
    tab.column[2] = dgsGridListAddColumn(tab.gridlist[1], 'Nazwa', 0.25)
    tab.column[3] = dgsGridListAddColumn(tab.gridlist[1], 'ID przedmiotu', 0.25)
    tab.column[4] = dgsGridListAddColumn(tab.gridlist[1], 'Wartość 1', 0.2)
    tab.column[5] = dgsGridListAddColumn(tab.gridlist[1], 'Wartość 2', 0.2)

    for i, item in pairs(items) do
        local row = dgsGridListAddRow(tab.gridlist[1])
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[1], tostring(item[5]), false, false)
        dgsGridListSetItemColor(tab.gridlist[1], row, tab.column[1], tocolor(150, 150, 150, 255))

        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[2], tostring(item[1]), false, false)
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[3], tostring(item[2]), false, false)
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[4], tostring(item[3]), false, false)
        dgsGridListSetItemText(tab.gridlist[1], row, tab.column[5], tostring(item[4]), false, false)
    end

    tab.button[1] = dgsCreateButton(10/zoom, 710*py, 225/zoom, 50*py, 'Dodaj przedmiot do listy', false, tab.window[1])
    tab.button[2] = dgsCreateButton(245/zoom, 710*py, 225/zoom, 50*py, 'Zapisz item', false, tab.window[1])

    tab.edit[1] = dgsCreateEdit(480/zoom, 710*py, 120/zoom, 50*py, '', false, tab.window[1])
    dgsEditSetPlaceHolder(tab.edit[1], 'Nazwa')
    dgsSetProperty(tab.edit[1], "placeHolderFont", font)

    tab.edit[2] = dgsCreateEdit(610/zoom, 710*py, 120/zoom, 50*py, '', false, tab.window[1])
    dgsEditSetPlaceHolder(tab.edit[2], 'ID')
    dgsSetProperty(tab.edit[2], "placeHolderFont", font)

    tab.edit[3] = dgsCreateEdit(740/zoom, 710*py, 120/zoom, 50*py, '', false, tab.window[1])
    dgsEditSetPlaceHolder(tab.edit[3], 'Wartość 1')
    dgsSetProperty(tab.edit[3], "placeHolderFont", font)

    tab.edit[4] = dgsCreateEdit(870/zoom, 710*py, 120/zoom, 50*py, '', false, tab.window[1])
    dgsEditSetPlaceHolder(tab.edit[4], 'Wartość 2')
    dgsSetProperty(tab.edit[4], "placeHolderFont", font)
    --

    for i, options in pairs(tab) do
        for j, gui in pairs(options) do
            if type(gui) == 'userdata' then
                dgsSetFont(gui, font)
            end
        end
    end
end)

addEventHandler('onDgsWindowClose', root, function()
    if source == tab.window[1] then
        showCursor(false)
        removeEventHandler('onDgsMouseClick', root, buttonFunctions)
        removeEventHandler('onDgsGridListSelect', root, gridListSelection)
    end
end)

function buttonFunctions(button, state)
    if state == "up" then
        if source == tab.button[1] then
            if dgsGetText(tab.button[1]) == "Usuń przedmiot" then
                if not dbid then
                    return
                end

                for i, item in pairs(items) do
                    if tonumber(item[5]) == tonumber(dbid) then
                        table.remove(items, i)
                    end
                end
                refreshData(items)

                triggerServerEvent('item-system:deleteItem', localPlayer, dbid)
            else
                local name = dgsGetText(tab.edit[1])
                local itemID = dgsGetText(tab.edit[2])
                local value1 = dgsGetText(tab.edit[3])
                local value2 = dgsGetText(tab.edit[4])
    
                if string.len(name) == 0 then
                    return
                end
                if string.len(itemID) == 0 then
                    return
                end
                if string.len(value1) == 0 then
                    return
                end
                if string.len(value2) == 0 then
                    return
                end

                table.insert(items, {name, itemID, value1, value2, 'NEW'})
                refreshData(items)

                triggerServerEvent('item-system:makeItem', localPlayer, name, itemID, value1, value2)
            end
            
        elseif source == tab.button[2] then
            local name = dgsGetText(tab.edit[1])
            local itemID = dgsGetText(tab.edit[2])
            local value1 = dgsGetText(tab.edit[3])
            local value2 = dgsGetText(tab.edit[4])

            if string.len(name) == 0 then
                return
            end
            if string.len(itemID) == 0 then
                return
            end
            if string.len(value1) == 0 then
                return
            end
            if string.len(value2) == 0 then
                return
            end

            if not dbid then
                return
            end
            
            for i, item in pairs(items) do
                if tonumber(item[5]) == tonumber(dbid) then
                    table.remove(items, i)
                    table.insert(items, i, {name, itemID, value1, value2, item[5]})
                end
            end
            refreshData(items)

            triggerServerEvent('item-system:saveItem', localPlayer, name, itemID, value1, value2, dbid)
        end
    end
end

function gridListSelection(current, currentcolumn, previous, previouscolumn)
    if source == tab.gridlist[1] then
        selected = dgsGridListGetSelectedItem(tab.gridlist[1])
        if selected ~= -1 then
            dgsSetText(tab.button[1], 'Usuń przedmiot')

            dbid = dgsGridListGetItemText(tab.gridlist[1], selected, 1)

            for i=2, 5 do
                dgsSetText(tab.edit[i-1], dgsGridListGetItemText(tab.gridlist[1], selected, i))
            end
        else
            dgsSetText(tab.button[1], 'Dodaj przedmiot do listy')
        end
    end
end