local fontt = dxCreateFont ( "karla.ttf" , 12)

addEventHandler("onClientRender", getRootElement(), function()
	local rx, ry, rz = getCameraMatrix()
	for i, v in pairs(getElementsByType("player")) do
		if getElementData(v, "loggedIn") == true then
			local bx,by,bz = getPedBonePosition(v, 8)
			local fx, fy = getScreenFromWorldPosition(bx, by, bz+0.4)
			if fx and fy then
				local sx, sy = math.floor(fx), math.floor(fy)
				local dist = getDistanceBetweenPoints3D(rx,ry,rz, bx,by,bz)
				local id = getElementData(v,"playerID")
				if dist >= 1 and dist <= 12 then
                    playerName = "#ffffff"..getPlayerName(v):gsub("_", " ").." #cccccc("..id..")"

                    if isPedDead(v) then
                        playerName = playerName..' #ff0000(ranny)'
                    end

					dxDrawText(playerName, sx+1, sy+6, sx, sy+5, tocolor(255, 255, 255, 240), 1, fontt, "center", "center",false,false,false,true,false)
				end
			end
		end
	end
	for i, v in pairs(getElementsByType("ped")) do
		if getElementData(v, "name") then
			local bx,by,bz = getPedBonePosition(v, 8)
			local fx, fy = getScreenFromWorldPosition(bx, by, bz+0.4)
			if fx and fy then
				local sx, sy = math.floor(fx), math.floor(fy)
				local dist = getDistanceBetweenPoints3D(rx,ry,rz, bx,by,bz)
				if dist >= 1 and dist <= 12 then
					dxDrawText(getElementData(v, "name").." (#00ccffBOT#ffffff)", sx+1, sy+6, sx, sy+5, tocolor(255, 255, 255, 240), 1, fontt, "center", "center",false,false,false,true,false)
				end
			end
		end
	end
end)