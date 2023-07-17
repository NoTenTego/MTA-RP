local sx, sy = guiGetScreenSize()
local px, py = (sx/1920), (sy/1080)
local zoom = 1
local fh = 1920
if sx < fh then
    zoom = math.min(2,fh/sx)
end

usefull = {"Użyj przedmiotu", "Zniszcz przedmiot", "Przekaż przedmiot"}

local fontBig = dxCreateFont ( ":hud/karla.ttf" , 17)
local fontSmall = dxCreateFont ( ":hud/karla.ttf" , 12)
local fontDesc = dxCreateFont ( ":hud/karla.ttf" , 14)

function renderEquipment()
    if not getElementData(localPlayer, "loggedIn") == true then 
        return 
    end

    local progress = (getTickCount() - tick) / 500

    local pos = {
        ['active'] = {
            ['window'] = {interpolateBetween(1920/zoom, 0, 0, 1320/zoom, 0, 0, progress, 'InQuad'), 340*py, 600/zoom, 500*py},
            ['name'] = {interpolateBetween(1920/zoom, 0, 0, 1327/zoom, 0, 0, progress, 'InQuad'), 342*py, 1920/zoom, 340*py},
            ['value_1'] = {interpolateBetween(2300/zoom, 0, 0, 1700/zoom, 0, 0, progress, 'InQuad'), 342*py, 1920/zoom, 340*py},
            ['value_2'] = {interpolateBetween(2415/zoom, 0, 0, 1815/zoom, 0, 0, progress, 'InQuad'), 342*py, 1920/zoom, 340*py},
        },
        ['unactive'] = {
            ['window'] = {interpolateBetween(1320/zoom, 0, 0, 1920/zoom, 0, 0, progress, 'InQuad'), 340*py, 600/zoom, 500*py},
            ['name'] = {interpolateBetween(1327/zoom, 0, 0, 1920/zoom, 0, 0, progress, 'InQuad'), 342*py, 1920/zoom, 340*py},
            ['value_1'] = {interpolateBetween(1700/zoom, 0, 0, 2300/zoom, 0, 0, progress, 'InQuad'), 342*py, 1920/zoom, 340*py},
            ['value_2'] = {interpolateBetween(1815/zoom, 0, 0, 2415/zoom, 0, 0, progress, 'InQuad'), 342*py, 1920/zoom, 340*py},
        },
    }

    dxDrawRectangle(pos[state]['window'][1], pos[state]['window'][2], pos[state]['window'][3], pos[state]['window'][4], tocolor(0, 0, 0, 150), true)
    dxDrawRectangle(pos[state]['window'][1], pos[state]['window'][2]+27*py, pos[state]['window'][3], 1*py, tocolor(255, 255, 255, 100), true)

    dxDrawText('Nazwa', pos[state]['name'][1], pos[state]['name'][2], pos[state]['name'][3], pos[state]['name'][4], tocolor(200, 200, 200), 1*py, fontSmall, 'left', 'top', false, false, true)
    dxDrawText('Wartość 1', pos[state]['value_1'][1], pos[state]['value_1'][2], pos[state]['value_1'][3], pos[state]['value_1'][4], tocolor(200, 200, 200), 1*py, fontSmall, 'left', 'top', false, false, true)
    dxDrawText('Wartość 2', pos[state]['value_2'][1], pos[state]['value_2'][2], pos[state]['value_2'][3], pos[state]['value_2'][4], tocolor(200, 200, 200), 1*py, fontSmall, 'left', 'top', false, false, true)

    itemsCount = 0
    local height = 30*py
    if not getElementData(localPlayer, 'items') then
        return
    end
    for i, item in pairs(getElementData(localPlayer, 'items')) do
        if i >= k and i <= n then 
            if i == l then
                dxDrawRectangle(pos[state]['window'][1], pos[state]['window'][2]+height+5*py, pos[state]['window'][3], 27*py, tocolor(0, 204, 255, 100), true)
                selectedItem = item

                if moreInfo then
                    local useFullHeight = 0*py
                    for i, v in ipairs(usefull) do
                        if i == infoItems then
                            dxDrawRectangle(pos[state]['window'][1]-205/zoom, pos[state]['window'][2]+height+5*py+useFullHeight, 200/zoom, 27*py, tocolor(0, 204, 255, 100), true)
                        else
                            dxDrawRectangle(pos[state]['window'][1]-205/zoom, pos[state]['window'][2]+height+5*py+useFullHeight, 200/zoom, 27*py, tocolor(0, 0, 0, 150), true)
                            if (i % 2 == 0) then
                                dxDrawRectangle(pos[state]['window'][1]-205/zoom, pos[state]['window'][2]+height+5*py+useFullHeight, 200/zoom, 27*py, tocolor(0, 0, 0, 50), true)
                            else
                                dxDrawRectangle(pos[state]['window'][1]-205/zoom, pos[state]['window'][2]+height+5*py+useFullHeight, 200/zoom, 27*py, tocolor(100, 100, 100, 20), true)
                            end
                        end
                        dxDrawText(v, pos[state]['window'][1]-202/zoom, pos[state]['window'][2]+height+5*py+useFullHeight, 200/zoom, 27*py, tocolor(230, 230, 230), 1*py, fontDesc, 'left', 'top', false, false, true)

                        useFullHeight = useFullHeight + 27*py
                    end
                end
            else
                if (i % 2 == 0) then
                    dxDrawRectangle(pos[state]['window'][1], pos[state]['window'][2]+height+5*py, pos[state]['window'][3], 27*py, tocolor(0, 0, 0, 50), true)
                else
                    dxDrawRectangle(pos[state]['window'][1], pos[state]['window'][2]+height+5*py, pos[state]['window'][3], 27*py, tocolor(100, 100, 100, 20), true)
                end
            end

            dxDrawText(item[1], pos[state]['name'][1], pos[state]['name'][2]+height, pos[state]['name'][3], pos[state]['name'][4], tocolor(230, 230, 230), 1*py, fontBig, 'left', 'top', false, false, true)
            dxDrawText(item[2], pos[state]['value_1'][1], pos[state]['value_1'][2]+height, pos[state]['value_1'][3], pos[state]['value_1'][4], tocolor(230, 230, 230), 1*py, fontBig, 'left', 'top', false, false, true)
            dxDrawText(item[3], pos[state]['value_2'][1], pos[state]['value_2'][2]+height, pos[state]['value_2'][3], pos[state]['value_2'][4], tocolor(230, 230, 230), 1*py, fontBig, 'left', 'top', false, false, true)

            height = height + 27*py
        end

        itemsCount = itemsCount + 1
    end
end


function openEquipment(key, keyState)
	if not getElementData(localPlayer, "loggedIn") == true then 
        return 
    end

    if isTimer(stateOffControl) then 
        return
    end
    if isTimer(stateOnControl) then 
        return
    end

    k = 1
    l = 1
    n = 17
    m = 17
    infoItems = 1

	if equipment then
        state = 'unactive'
        tick = getTickCount()
        moreInfo = nil
        toggleControl ("fire", true) 
        stateOffControl = setTimer(function()
            removeEventHandler("onClientRender", root, renderEquipment)
            equipment = nil
        end, 500, 1)
	else
		addEventHandler("onClientRender", root, renderEquipment)
		tick = getTickCount()
        equipment = true
        state = 'active'
        toggleControl ("fire", false) 
        stateOnControl = setTimer(function()end, 500, 1)
	end
end
addEvent('item-system:openEquipment', true)
addEventHandler('item-system:openEquipment', root, openEquipment)
bindKey("p", "down", openEquipment)

function closeEquipment()
    if equipment then
        state = 'unactive'
        tick = getTickCount()
        moreInfo = nil
        toggleControl ("fire", true) 
        setTimer(function()
            removeEventHandler("onClientRender", root, renderEquipment)
            equipment = nil
        end, 500, 1)
    end
end
addEvent("item-system:closeEquipment", true)
addEventHandler("item-system:closeEquipment", root, closeEquipment)

bindKey("mouse_wheel_down", "both", function()
	if equipment then
		if not moreInfo then
			if not (n >= itemsCount) then
				k = k+1
				n = n+1
				l = l+1
			else
				if l > 16+(itemsCount-m) then return end
				l = l+1
			end
		else
			if infoItems > 0 and infoItems < #usefull then
				infoItems = infoItems + 1
			end
		end
	end
end)

bindKey("mouse_wheel_up", "both", function()
	if equipment then
		if not moreInfo then
			if not (n == m) then
				k = k-1
				n = n-1
				l = l-1
			else
				if l == 1 then return end
				l = l-1 
			end
		else
			if infoItems > 1 then
				infoItems = infoItems - 1
			end
		end
	end
end)

bindKey("mouse1", "down", function()
	if equipment then
		if moreInfo then
			if infoItems == 1 then
                triggerServerEvent('item-system:useItem', localPlayer, selectedItem[1], selectedItem[2], selectedItem[3], selectedItem[4], selectedItem[5])
            elseif infoItems == 2 then
                triggerServerEvent('item-system:destroyItem', localPlayer, selectedItem[1], selectedItem[2], selectedItem[3], selectedItem[4], selectedItem[5])
                if l > 16+(itemsCount-m) then
                    l = l-1
                end
                if l > 16 then
                    k = k-1
                    n = n-1
                end
            else

            end
            moreInfo = false
            infoItems = 1
		else
			moreInfo = true
		end
	end
end)

bindKey("mouse2", "down", function()
	if equipment then
		if moreInfo then
			moreInfo = false
            infoItems = 1
		end
	end
end)