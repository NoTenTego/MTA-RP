local font = dxCreateFont("karla.ttf", 13)

local sx, sy = guiGetScreenSize()
local px, py = (sx/1920), (sy/1080)
local zoom = 1
local fh = 1920
if sx < fh then
    zoom = math.min(2,fh/sx)
end

local notifications = {}
local animationTicks = {}
 
function sendNotification(description)
    if #notifications > 2 then
        return
    end
    table.insert(notifications, {description, getTickCount()})
    
    setTimer(function()
        table.remove(notifications, 1)
        table.remove(animationTicks, 1)
    end, 16000, 1)
end
addEvent('hud:sendNotification', true)
addEventHandler('hud:sendNotification', root, sendNotification)

addEventHandler("onClientRender", root, function()
    if not getElementData(localPlayer, 'loggedIn') == true then
        return
    end

    if #notifications > 0 then
        local height = 0
        for i, notification in pairs(notifications) do
            local progressEnter = getTickCount() - notification[2]
            local progress = progressEnter/1000

            local textWidth, textHeight = dxGetTextSize(notification[1], 363*py, 1, 1, font, true)
            
            if progress >= 15 then

                if not animationTicks[i] then
                    animationTicks[i] = getTickCount()
                end

                local progressExit = getTickCount() - animationTicks[i]
                local progressLeave = progressExit/1000

                dxDrawRectangle(19/zoom, interpolateBetween((820-height)*py, 0, 0, 890*py, 0, 0, progressLeave, 'InQuad'), 363/zoom, (-textHeight-5)*py, tocolor(0, 0, 0, 175))
                dxDrawText(notification[1], 25/zoom, interpolateBetween(((816-height)-textHeight)*py, 0, 0, ((886)-textHeight)*py, 0, 0, progressLeave, 'InQuad'), textWidth+6, 1920*py, tocolor(255, 255, 255), 1*py, font, "left", "top", false, true)
            else
                dxDrawRectangle(19/zoom, interpolateBetween(890*py, 0, 0, (820-height)*py, 0, 0, progress, 'InQuad'), 363/zoom, (-textHeight-5)*py, tocolor(0, 0, 0, 175))
                dxDrawText(notification[1], 25/zoom, interpolateBetween(((886)-textHeight)*py, 0, 0, ((816-height)-textHeight)*py, 0, 0, progress, 'InQuad'), textWidth+6, 1920*py, tocolor(255, 255, 255), 1*py, font, "left", "top", false, true)
            end
            height = height + textHeight + 11
        end
    end
end)