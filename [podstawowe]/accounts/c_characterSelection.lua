local sm = {}
sm.moov = 0

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local start
local animTime
local tempPos = {{},{}}
local tempPos2 = {{},{}}

local function camRender()
	local now = getTickCount()
	if (sm.moov == 1) then
		local x1, y1, z1 = interpolateBetween(tempPos[1][1], tempPos[1][2], tempPos[1][3], tempPos2[1][1], tempPos2[1][2], tempPos2[1][3], (now-start)/animTime, "InOutQuad")
		local x2,y2,z2 = interpolateBetween(tempPos[2][1], tempPos[2][2], tempPos[2][3], tempPos2[2][1], tempPos2[2][2], tempPos2[2][3], (now-start)/animTime, "InOutQuad")
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientRender",root,camRender)
		fadeCamera(true)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1) then
		if isTimer(timer1) then
			killTimer(timer1)
		end
		if isTimer(timer2) then
			killTimer(timer2)
		end
		removeEventHandler("onClientRender",root,camRender)
		fadeCamera(true)
	end
	fadeCamera(true)
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	if not isElement(blur) then
		timer2 = setTimer(fadeCamera, time-1000, 1, false)
	end
	start = getTickCount()
	animTime = time
	tempPos[1] = {x1,y1,z1}
	tempPos[2] = {x1t,y1t,z1t}
	tempPos2[1] = {x2,y2,z2}
	tempPos2[2] = {x2t,y2t,z2t}
	addEventHandler("onClientRender",root,camRender)
	return true
end

function isMouseInPosition ( x, y, width, height )
	if ( not isCursorShowing( ) ) then
		return false
	end
	local sx, sy = guiGetScreenSize ( )
	local cx, cy = getCursorPosition ( )
	local cx, cy = ( cx * sx ), ( cy * sy )
	
	return ( ( cx >= x and cx <= x + width ) and ( cy >= y and cy <= y + height ) )
end

local function characterSelection(charactersData)
	character = {}
	charactersRenderedData = charactersData
	local moveX = 0
	numberOfCharacters = 0
	selectedCharacter = 1
	for i, value in ipairs(charactersData) do
		character[i] = createPed(value['skin'], 848.72791748047-moveX, -1962.4061279297, 12.8671875, 180)
		setElementDimension(character[i], getElementDimension(localPlayer))
		moveX = moveX + 1.5
		numberOfCharacters = numberOfCharacters + 1
	end
	setPedAnimation(character[1], "dealer", "dealer_idle_02", -1, true, false)
end

function renderCharacterData ()
	dxDrawRectangle(795/zoom, 950*py, 330/zoom, 80*py, tocolor(0, 0, 0, 130), true)
	
	for i, v in ipairs(charactersRenderedData) do
		if i == selectedCharacter then
			dxDrawText(v['name']..' '..v['surname'], 800/zoom, 970*py, 1920/zoom, 970*py, tocolor(0, 204, 255, 255), 1*py, fontSmallTwo, "left", "center", false, true, true)
			dxDrawText(v['class'].."   Portfel: $"..v['money'], 800/zoom, 997*py, 1920/zoom, 1000*py, tocolor(255, 255, 255, 200), 1*py, fontSmall, "left", "center", false, true, true)
			dxDrawText("Wzrost: "..v['height'].."   Waga: "..v['weight'], 800/zoom, 1016*py, 1920/zoom, 1016*py, tocolor(255, 255, 255, 200), 1*py, fontSmall, "left", "center", false, true, true)
		end
	end

	if numberOfCharacters > 1 then
		if numberOfCharacters > selectedCharacter then
			if isMouseInPosition(545/zoom, 980*py, 240/zoom, 50*py) then
				dxDrawRectangle(545/zoom, 980*py, 240/zoom, 50*py, tocolor(0, 0, 0, 180), true) --lewo
				dxDrawText("Poprzednia postać", 665/zoom, 1003*py, 665/zoom, 1003*py, tocolor(255, 255, 255, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
			else
				dxDrawRectangle(545/zoom, 980*py, 240/zoom, 50*py, tocolor(0, 0, 0, 150), true) --lewo
				dxDrawText("Poprzednia postać", 665/zoom, 1003*py, 665/zoom, 1003*py, tocolor(200, 200, 200, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
			end
		end

		if selectedCharacter > 1 then
			if isMouseInPosition(1135/zoom, 980*py, 240/zoom, 50*py) then
				dxDrawRectangle(1135/zoom, 980*py, 240/zoom, 50*py, tocolor(0, 0, 0, 180), true) --prawo
				dxDrawText("Następna postać", 1255/zoom, 1003*py, 1255/zoom, 1003*py, tocolor(255, 255, 255, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
			else
				dxDrawRectangle(1135/zoom, 980*py, 240/zoom, 50*py, tocolor(0, 0, 0, 150), true) --prawo
				dxDrawText("Następna postać", 1255/zoom, 1003*py, 1255/zoom, 1003*py, tocolor(200, 200, 200, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
			end
		end
	end

	if isMouseInPosition(845/zoom, 30*py, 230/zoom, 50*py) then
		dxDrawRectangle(845/zoom, 30*py, 230/zoom, 50*py, tocolor(0, 0, 0, 180), true)
		dxDrawText("Wejdź do gry", 959/zoom, 53*py, 959/zoom, 53*py, tocolor(255, 255, 255, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
	else
		dxDrawRectangle(845/zoom, 30*py, 230/zoom, 50*py, tocolor(0, 0, 0, 150), true)
		dxDrawText("Wejdź do gry", 959/zoom, 53*py, 959/zoom, 53*py, tocolor(200, 200, 200, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
	end

	if numberOfCharacters ~= 2 then
		if isMouseInPosition(845/zoom, 90*py, 230/zoom, 50*py) then
			dxDrawRectangle(845/zoom, 90*py, 230/zoom, 50*py, tocolor(0, 0, 0, 180), true)
			dxDrawText("Stwórz postać", 959/zoom, 113*py, 959/zoom, 113*py, tocolor(255, 255, 255, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
		else
			dxDrawRectangle(845/zoom, 90*py, 230/zoom, 50*py, tocolor(0, 0, 0, 150), true)
			dxDrawText("Stwórz postać", 959/zoom, 113*py, 959/zoom, 113*py, tocolor(200, 200, 200, 255), 1*py, fontSmallTwo, "center", "center", false, true, true)
		end
	end
end

function mouseInPosition(button, state)
	if state == "up" then
		if isTimer(timerL) or isTimer(timerR) then return end

		if isMouseInPosition(545/zoom, 980*py, 240/zoom, 50*py) then
			if numberOfCharacters > selectedCharacter then
				if isTimer(timerLeft) or isTimer(timerRight) then return end
				local x, y, z, lx, ly, lz = getCameraMatrix ()
				smoothMoveCamera(x, y, z, lx, ly, lz, x-1.5, y, z, lx, ly, lz, 1000)
				timerLeft = setTimer(function ()
					selectedCharacter = selectedCharacter + 1
					for i, v in ipairs(character) do
						setPedAnimation(v)
					end
					setPedAnimation(character[selectedCharacter], "dealer", "dealer_idle_02", -1, true, false)
				end, 1000, 1)
			end
		elseif isMouseInPosition(1135/zoom, 980*py, 240/zoom, 50*py) then
			if selectedCharacter > 1 then
				if isTimer(timerRight) or isTimer(timerLeft) then return end
				local x, y, z, lx, ly, lz = getCameraMatrix ()
				smoothMoveCamera(x, y, z, lx, ly, lz, x+1.5, y, z, lx, ly, lz, 1000)
				timerRight = setTimer(function ()
					selectedCharacter = selectedCharacter - 1
					for i, v in ipairs(character) do
						setPedAnimation(v)
					end
					setPedAnimation(character[selectedCharacter], "dealer", "dealer_idle_02", -1, true, false)
				end, 1000, 1)
			end
		elseif isMouseInPosition(845/zoom, 30*py, 230/zoom, 50*py) then
			fadeCamera(false)
			setTimer(function ()
				setCameraTarget(localPlayer)
				showChat(true)
				showCursor(false)
				removeEventHandler("onClientRender", root, renderCharacterData)
				removeEventHandler("onClientClick", root, mouseInPosition)
				triggerServerEvent("accounts:spawnCharacter", localPlayer, charactersRenderedData[selectedCharacter])
				fadeCamera(true)
				for i, v in ipairs(character) do
					if isElement(v) then
						destroyElement(v)
					end
				end
			end, 1000, 1)
		elseif isMouseInPosition(845/zoom, 90*py, 230/zoom, 50*py) then
			if numberOfCharacters ~= 2 then
				removeEventHandler("onClientRender", root, renderCharacterData)
				removeEventHandler("onClientClick", root, mouseInPosition)
				triggerEvent("accounts:newCharacter", localPlayer)
				for i, v in ipairs(character) do
					destroyElement(v)
				end
			end
		end
	end
end

addEvent("accounts:characterSelection", true)
addEventHandler("accounts:characterSelection", root, function(charactersData)
	destroyLoginPanel()
	fadeCamera(false)

	setTimer(function()
		characterSelection(charactersData)
		setCameraMatrix(848.95791748047, -1965.9711425781, 13.5, 750, 0, -300, 0, 0)

		addEventHandler("onClientRender", root, renderCharacterData)
		addEventHandler("onClientClick", root, mouseInPosition)

		fadeCamera(true)
	end, 1000, 1)
end)