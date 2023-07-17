function takePosition()
	local x, y, z = getElementPosition(localPlayer)
	setClipboard (x..", "..y..", "..z)
	triggerEvent('hud:sendNotification', localPlayer, 'Pomyślnie skopiowano pozycje twojej kamery.')
end
addCommandHandler("getpos", takePosition)

function takeCameraPosition()
	local x, y, z, lx, ly, lz = getCameraMatrix ()
	setClipboard (x..", "..y..", "..z..", "..lx..", "..ly..", "..lz)
	triggerEvent('hud:sendNotification', localPlayer, 'Pomyślnie skopiowano twoją pozycje.')
end
addCommandHandler("getcam", takeCameraPosition)