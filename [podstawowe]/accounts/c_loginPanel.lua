loadstring(exports.dgs:dgsImportFunction())()

--utils
local function dxDrawLinedRectangle( x, y, width, height, color, _width, postGUI )
	_width = _width or 1
	dxDrawLine ( x, y, x+width, y, color, _width, postGUI )
	dxDrawLine ( x, y, x, y+height, color, _width, postGUI )
	dxDrawLine ( x, y+height, x+width, y+height, color, _width, postGUI )
	return dxDrawLine ( x+width, y, x+width, y+height, color, _width, postGUI )
end

--opcje
font = dxCreateFont("font.ttf", 25)
fontSmaller = dxCreateFont("font.ttf", 20)
fontSmall = dxCreateFont("font.ttf", 11)
fontSmallTwo = dxCreateFont("font.ttf", 15)

local components = { "ammo", "area_name", "armour", "breath", "clock", "health", "money", "radar", "vehicle_name", "weapon", "radio", "wanted"}

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
	for i, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
	end
end)

--skalowanie
sx,sy = guiGetScreenSize()
px, py = (sx/1920), (sy/1080)
zoom = 1
fh = 1920
if sx < fh then
    zoom = math.min(2,fh/sx)
end

local animateScreen = { 
	[1] = {2079.1259765625, -1653.15234375, 40.260612487793, 2079.38671875, -1845.08203125, 32.534748077393},
	[2] = {1569.8271484375, -1735.2900390625, 47.129894256592, 1539.169921875, -1649.8603515625, 35.231113433838},
	[3] = {1061.33984375, -1420.44921875, 47.626876831055, 1099.658203125, -1327.173828125, 37.626876831055},
	[4] = {1204.087890625, -1405.9521484375, 33.792552947998, 1270.3564453125, -1408.14453125, 26.263690948486 },
	[5] = {1966.607421875, -1170.673828125, 45.119743347168, 1966.607421875, -1170.673828125, 35.119743347168},
}

local function shuffleScreen()
	local rand = math.random(1, #animateScreen)
	if rand ~= old then
		old_screen = rand
		return animateScreen[ rand ]
	else
		return shuffleScreen( old )
	end
end

local moved = 199
local speed = 0.10

local function slideScreen()
	local matrix = { getCameraMatrix ( localPlayer ) }
	matrix[1] = matrix[1] + speed
	moved = moved + speed
	if moved > 200 then
		local scr = shuffleScreen()
		moved = 0
		setCameraMatrix ( scr[1], scr[2], scr[3], scr[4], scr[5], scr[6], 0 )
	else
		setCameraMatrix ( unpack(matrix) )
	end
end

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function ()
	if getElementData(localPlayer, "loggedIn") == true then 
        return 
    end

	showChat(false)
	fadeCamera(true)
	showCursor(true)

	panel = "login"

    addEventHandler("onClientRender", root, renderPanel)
	addEventHandler("onDgsMouseClick", root, dgsMouseClick)

	blur = dgsCreateBlurBox(400/zoom, 200*py)
	imageBlur = dgsCreateImage(0/zoom, 0*py, 1920/zoom, 1080*py, blur, false)
	dgsSetEnabled(imageBlur, false)

	dgsPanel('login')
end)

pos = {
	['login'] = {
		['window'] = {0/zoom, 340*py, 1920/zoom, 400*py},
		['login'] = {785/zoom, 390*py, 350/zoom, 65*py},
		['password'] = {785/zoom, 465*py, 350/zoom, 65*py},
		['joinToGame'] = {785/zoom, 540*py, 350/zoom, 65*py},
		['switchpanel'] = {785/zoom, 615*py, 350/zoom, 65*py},
		['notification'] = {960/zoom, 705*py, 960/zoom, 705*py},
	},
	['register'] = {
		['window'] = {0/zoom, 299*py, 1920/zoom, 570*py},
		['login'] = {785/zoom, 360*py, 350/zoom, 65*py},
		['email'] = {785/zoom, 435*py, 350/zoom, 65*py},
		['password'] = {785/zoom, 510*py, 350/zoom, 65*py},
		['confirmPassword'] = {785/zoom, 585*py, 350/zoom, 65*py},
		['joinToGame'] = {785/zoom, 660*py, 350/zoom, 65*py},
		['switchpanel'] = {785/zoom, 735*py, 350/zoom, 65*py},
		['notification'] = {960/zoom, 830*py, 960/zoom, 830*py},
	},
}

tab = {
	edit = {},
	button = {},
	memo = {},
	switch = {},
	comboBox = {},
}

function dgsPanel(panel)
	if panel == "login" then
		tab.edit[1] = dgsCreateEdit(pos[panel]['login'][1], pos[panel]['login'][2], pos[panel]['login'][3], pos[panel]['login'][4], "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(255, 255, 255, 0), false)
		dgsSetFont(tab.edit[1], font)
		dgsSetPostGUI(tab.edit[1], true)
		dgsEditSetPlaceHolder(tab.edit[1], 'Login')
		dgsSetProperty(tab.edit[1], "placeHolderFont", font)
		dgsSetProperty(tab.edit[1], "placeHolderColor", tocolor(230, 230, 230, 255))

		tab.edit[2] = dgsCreateEdit(pos[panel]['password'][1], pos[panel]['password'][2], pos[panel]['password'][3], pos[panel]['password'][4], "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(255, 255, 255, 0), false)
		dgsSetFont(tab.edit[2], font)
		dgsSetPostGUI(tab.edit[2], true)
		dgsEditSetPlaceHolder(tab.edit[2], 'Hasło')
		dgsSetProperty(tab.edit[2], "placeHolderFont", font)
		dgsSetProperty(tab.edit[2], "placeHolderColor", tocolor(230, 230, 230, 255))
		dgsEditSetMasked(tab.edit[2], true)

		tab.button[1] = dgsCreateButton(pos[panel]['joinToGame'][1], pos[panel]['joinToGame'][2], pos[panel]['joinToGame'][3], pos[panel]['joinToGame'][4], 'Wejdź do gry!', false, nil, tocolor(0, 0, 0, 200), 1/zoom, 1*py, nil, nil, nil, tocolor(230, 230, 230, 255))
		dgsSetFont(tab.button[1], font)
		dgsSetPostGUI(tab.button[1], true)
		tab.button[2] = dgsCreateButton(pos[panel]['switchpanel'][1], pos[panel]['switchpanel'][2], pos[panel]['switchpanel'][3], pos[panel]['switchpanel'][4], 'Stwórz konto!', false, nil, tocolor(0, 0, 0, 200), 1/zoom, 1*py    , nil, nil, nil, tocolor(230, 230, 230, 255))
		dgsSetFont(tab.button[2], font)
		dgsSetPostGUI(tab.button[2], true)
	end
end

function changeDgspanel()
	dgsSetPosition(tab.edit[1], pos[panel]['login'][1], pos[panel]['login'][2], false)
	dgsSetPosition(tab.button[1], pos[panel]['joinToGame'][1], pos[panel]['joinToGame'][2], false)
	dgsSetPosition(tab.button[2], pos[panel]['switchpanel'][1], pos[panel]['switchpanel'][2], false)

	if panel == 'login' then
		dgsSetPosition(tab.edit[2], pos[panel]['password'][1], pos[panel]['password'][2], false)
	end
end

function dgsMouseClick(button, state)
	if state == "up" then
		if source == tab.button[1] then
			if panel == 'login' then
				local username = dgsGetText(tab.edit[1]) or ''
				local password = dgsGetText(tab.edit[2]) or ''
				triggerServerEvent('accounts:verifyLogin', localPlayer, username, password)
			else
				local username = dgsGetText(tab.edit[1]) or ''
				local email = dgsGetText(tab.edit[2]) or ''
				local password = dgsGetText(tab.edit[3]) or ''
				local confirmPassword = dgsGetText(tab.edit[4]) or ''
				triggerServerEvent('accounts:registerAccount', localPlayer, username, email, password, confirmPassword)
			end
		elseif source == tab.button[2] then
			if panel == 'login' then
				panel = 'register'
				dgsSetPosition(tab.edit[2], pos[panel]['email'][1], pos[panel]['email'][2], false)

				tab.edit[3] = dgsCreateEdit(pos[panel]['password'][1], pos[panel]['password'][2], pos[panel]['password'][3], pos[panel]['password'][4], "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(255, 255, 255, 0), false)
				dgsSetFont(tab.edit[3], font)
				dgsSetPostGUI(tab.edit[3], true)
				dgsEditSetPlaceHolder(tab.edit[3], 'Hasło')
				dgsSetProperty(tab.edit[3], "placeHolderFont", font)
				dgsSetProperty(tab.edit[3], "placeHolderColor", tocolor(230, 230, 230, 255))
				dgsEditSetMasked(tab.edit[3], true)

				tab.edit[4] = dgsCreateEdit(pos[panel]['confirmPassword'][1], pos[panel]['confirmPassword'][2], pos[panel]['confirmPassword'][3], pos[panel]['confirmPassword'][4], "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(255, 255, 255, 0), false)
				dgsSetFont(tab.edit[4], font)
				dgsSetPostGUI(tab.edit[4], true)
				dgsEditSetPlaceHolder(tab.edit[4], 'Powtórz Hasło')
				dgsSetProperty(tab.edit[4], "placeHolderFont", font)
				dgsSetProperty(tab.edit[4], "placeHolderColor", tocolor(230, 230, 230, 255))
				dgsEditSetMasked(tab.edit[4], true)

				dgsSetText(tab.button[1], 'Stwórz konto!')
				dgsSetText(tab.button[2], 'Już posiadam konto!')
				dgsEditSetPlaceHolder(tab.edit[2], 'Email')
				dgsEditSetMasked(tab.edit[2], false)
				dgsSetText(tab.edit[2], '')
			else
				panel = 'login'
				destroyElement(tab.edit[3])
				destroyElement(tab.edit[4])
				dgsSetText(tab.button[1], 'Wejdź do gry!')
				dgsSetText(tab.button[2], 'Stwórz konto!')
				dgsEditSetPlaceHolder(tab.edit[2], 'Hasło')
				dgsEditSetMasked(tab.edit[2], true)
				dgsSetText(tab.edit[2], '')
			end
			changeDgspanel()
			notification = nil
		end
	end
end

function renderPanel()
    slideScreen()

	dxDrawRectangle(pos[panel]['window'][1], pos[panel]['window'][2], pos[panel]['window'][3], pos[panel]['window'][4], tocolor(0, 0, 0, 70))

	dxDrawLinedRectangle(pos[panel]['login'][1], pos[panel]['login'][2], pos[panel]['login'][3], pos[panel]['login'][4], tocolor(200, 200, 200, 255), 2)
	dxDrawLinedRectangle(pos[panel]['password'][1], pos[panel]['password'][2], pos[panel]['password'][3], pos[panel]['password'][4], tocolor(200, 200, 200, 255), 2)

	if panel == 'register' then
		dxDrawLinedRectangle(pos[panel]['email'][1], pos[panel]['email'][2], pos[panel]['email'][3], pos[panel]['email'][4], tocolor(200, 200, 200, 255), 2)
		dxDrawLinedRectangle(pos[panel]['confirmPassword'][1], pos[panel]['confirmPassword'][2], pos[panel]['confirmPassword'][3], pos[panel]['confirmPassword'][4], tocolor(200, 200, 200, 255), 2)
	end

	if notification then
		dxDrawText(notification, pos[panel]['notification'][1], pos[panel]['notification'][2], pos[panel]['notification'][3], pos[panel]['notification'][4], tocolor(255, 255, 255, 255), 1, fontSmaller, 'center', 'center')
	end
end

addEvent("accounts:notification", true)
addEventHandler("accounts:notification", root, function(text)
	notification = text
end)

function destroyLoginPanel()
	panel = nil

	removeEventHandler("onClientRender", root, renderPanel)
	removeEventHandler("onDgsMouseClick", root, dgsMouseClick)

	if isElement(blur) then
		destroyElement(blur)
		destroyElement(imageBlur)
		destroyElement(tab.button[1])
		destroyElement(tab.button[2])
		destroyElement(tab.edit[1])
		destroyElement(tab.edit[2])
	end

	if isElement(tab.edit[3]) and isElement(tab.edit[4]) then
		destroyElement(tab.edit[3])
		destroyElement(tab.edit[4])
	end
end