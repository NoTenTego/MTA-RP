
local boxHeight = 230

local maleSkins = {1, 2, 7, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33, 34, 35, 36, 37, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 67, 68, 70, 71, 72, 73, 78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133, 134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 163, 164, 165, 166, 167, 168, 170, 171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 200, 202, 203, 204, 206, 209, 210, 212, 213, 217, 220, 221, 222, 223, 227, 228, 229, 230, 234, 235, 236, 239, 240, 241, 242, 247, 248, 249, 250, 252, 253, 254, 255, 258, 259, 260, 261, 262, 264, 265, 266, 267, 268, 269, 270, 271, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 290, 291, 292, 293, 294, 295, 296, 297, 299, 300, 301, 302, 303, 305, 306, 307, 308, 309, 310, 311, 312}
local femaleSkins = {9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 69, 75, 76, 77, 85, 87, 88, 89, 90, 91, 92, 93, 129, 130, 131, 138, 139, 140, 141, 145, 148, 150, 151, 152, 157, 169, 172, 178, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 218, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245, 246, 251, 256, 257, 263, 298, 304}

local function makeNewCharacter()
	character = createPed(11, 848.72791748047, -1962.4061279297, 12.8671875, 180)
	setElementDimension(character, getElementData(localPlayer, "accountID"))

	tab.edit[1] = dgsCreateEdit(100/zoom, boxHeight*py, 200/zoom, 50*py, "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(0, 0, 0, 150), false)
	dgsSetFont(tab.edit[1], font)
	dgsEditSetMaxLength(tab.edit[1], 20)
    dgsEditSetPlaceHolder(tab.edit[1], 'Imię')
	dgsSetProperty(tab.edit[1], "placeHolderFont", font)
	dgsSetProperty(tab.edit[1], "placeHolderColor", tocolor(230, 230, 230, 255))

	tab.edit[2] = dgsCreateEdit(310/zoom, boxHeight*py, 200/zoom, 50*py, "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(0, 0, 0, 150), false)
	dgsSetFont(tab.edit[2], font)
	dgsEditSetMaxLength(tab.edit[2], 30)
    dgsEditSetPlaceHolder(tab.edit[2], 'Nazwisko')
	dgsSetProperty(tab.edit[2], "placeHolderFont", font)
	dgsSetProperty(tab.edit[2], "placeHolderColor", tocolor(230, 230, 230, 255))

	tab.memo[1] = dgsCreateMemo(100/zoom, (boxHeight+60)*py, 410/zoom, 200*py, "Krótki opis postaci", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(0, 0, 0, 150), false)
	dgsSetFont(tab.memo[1], fontSmaller)
	dgsMemoSetWordWrapState(tab.memo[1], 2)
	dgsMemoSetMaxLength(tab.memo[1], 200)
	dgsSetProperty(tab.memo[1], "placeHolderFont", font)
	dgsSetProperty(tab.memo[1], "placeHolderColor", tocolor(230, 230, 230, 255))

	tab.switch[1] = dgsCreateSwitchButton(100/zoom, (boxHeight+270)*py, 410/zoom, 50*py, "Kobieta", "Mężczyzna", false, false, false, tocolor(230, 230, 230, 255), tocolor(230, 230, 230, 255))
	dgsSetProperty(tab.switch[1], "colorOff", tocolor(0, 0, 0, 150))
	dgsSetProperty(tab.switch[1], "colorOn", tocolor(0, 0, 0, 150))
	dgsSetProperty(tab.switch[1], "font", fontSmaller)
	dgsSetProperty(tab.switch[1], "cursorColor", {tocolor(0, 0, 0, 150), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200)})

	tab.edit[3] = dgsCreateEdit(100/zoom, (boxHeight+330)*py, 130/zoom, 50*py, "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(0, 0, 0, 150), false)
	dgsSetFont(tab.edit[3], font)
	dgsEditSetPlaceHolder(tab.edit[3], 'Wzrost')
	dgsSetProperty(tab.edit[3], "placeHolderFont", font)
	dgsSetProperty(tab.edit[3], "placeHolderColor", tocolor(230, 230, 230, 255))
	dgsEditSetTextFilter(tab.edit[3], "[a-zA-Z]")
	dgsEditSetMaxLength(tab.edit[3], 3)

	tab.edit[4] = dgsCreateEdit(240/zoom, (boxHeight+330)*py, 130/zoom, 50*py, "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(0, 0, 0, 150), false)
	dgsSetFont(tab.edit[4], font)
	dgsEditSetPlaceHolder(tab.edit[4], 'Waga')
	dgsSetProperty(tab.edit[4], "placeHolderFont", font)
	dgsSetProperty(tab.edit[4], "placeHolderColor", tocolor(230, 230, 230, 255))
	dgsEditSetTextFilter(tab.edit[4], "[a-zA-Z]")
	dgsEditSetMaxLength(tab.edit[4], 3)

	tab.edit[5] = dgsCreateEdit(380/zoom, (boxHeight+330)*py, 130/zoom, 50*py, "", false, nil, tocolor(230, 230, 230, 255), 1/zoom, 1*py, false, tocolor(0, 0, 0, 150), false)
	dgsSetFont(tab.edit[5], font)
	dgsEditSetPlaceHolder(tab.edit[5], 'Wiek')
	dgsSetProperty(tab.edit[5], "placeHolderFont", font)
	dgsSetProperty(tab.edit[5], "placeHolderColor", tocolor(230, 230, 230, 255))
	dgsEditSetTextFilter(tab.edit[5], "[a-zA-Z]")
	dgsEditSetMaxLength(tab.edit[5], 2)

	tab.comboBox[1] = dgsCreateComboBox(100/zoom, (boxHeight+390)*py, 410/zoom, 50*py, "Wybierz skin postaci", false, false, 22, tocolor(230, 230, 230, 255), 1, 1, false, false, false, tocolor(0, 0, 0, 150))
	dgsSetFont(tab.comboBox[1], fontSmallTwo)
	dgsSetProperty(tab.comboBox[1], "itemColor", {tocolor(0, 0, 0, 150), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200)})
	for i, value in ipairs(maleSkins) do
		dgsComboBoxAddItem(tab.comboBox[1], value)
	end

	tab.comboBox[2] = dgsCreateComboBox(100/zoom, (boxHeight+390)*py, 410/zoom, 50*py, "Wybierz skin postaci", false, false, 22, tocolor(230, 230, 230, 255), 1, 1, false, false, false, tocolor(0, 0, 0, 150))
	dgsSetFont(tab.comboBox[2], fontSmallTwo)
	dgsSetProperty(tab.comboBox[2], "itemColor", {tocolor(0, 0, 0, 150), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200)})
	dgsSetVisible(tab.comboBox[2], false)
	dgsSetEnabled(tab.comboBox[2], false)
	for i, value in ipairs(femaleSkins) do
		dgsComboBoxAddItem(tab.comboBox[2], value)
	end

	tab.comboBox[3] = dgsCreateComboBox(100/zoom, (boxHeight+450)*py, 410/zoom, 50*py, "Wybierz klase postaci", false, false, 30, tocolor(230, 230, 230, 255), 1, 1, false, false, false, tocolor(0, 0, 0, 150))
	dgsSetFont(tab.comboBox[3], fontSmallTwo)
	dgsSetProperty(tab.comboBox[3], "itemColor", {tocolor(0, 0, 0, 150), tocolor(0, 0, 0, 200), tocolor(0, 0, 0, 200)})
	dgsComboBoxAddItem(tab.comboBox[3], 'Biznesmen')
	dgsComboBoxAddItem(tab.comboBox[3], 'Gangster')
	dgsComboBoxAddItem(tab.comboBox[3], 'chuj z frakcji')

	tab.button[1] = dgsCreateButton(100/zoom, (boxHeight+520)*py, 410/zoom, 80*py, 'Stwórz postać!', false, nil, tocolor(0, 0, 0, 200), 1/zoom, 1*py, nil, nil, nil, tocolor(230, 230, 230, 255))
	dgsSetFont(tab.button[1], font)

	tab.button[2] = dgsCreateButton(100/zoom, (boxHeight+610)*py, 410/zoom, 55*py, 'Wybór postaci', false, nil, tocolor(0, 0, 0, 200), 1/zoom, 1*py, nil, nil, nil, tocolor(230, 230, 230, 255))
	dgsSetFont(tab.button[2], font)
end

function onSelected(current,previous)
	if source == tab.comboBox[1] or source == tab.comboBox[2] then
		setElementModel(character, dgsComboBoxGetItemText(source, current))
	end
end

local function destroyCharacterCreatingPanel()
	destroyElement(tab.edit[1])
	destroyElement(tab.edit[2])
	destroyElement(tab.edit[3])
	destroyElement(tab.edit[4])
	destroyElement(tab.edit[5])
	destroyElement(tab.memo[1])
	destroyElement(tab.switch[1])
	destroyElement(tab.comboBox[1])
	destroyElement(tab.comboBox[2])
	destroyElement(tab.comboBox[3])
	destroyElement(tab.button[1])
	destroyElement(tab.button[2])

	removeEventHandler("onDgsComboBoxSelect", getRootElement(), onSelected)
	removeEventHandler("onDgsMouseClick", root, getCharacterData)
	removeEventHandler("onClientRender", root, renderNewCharacter)

	destroyElement(character)
end

function getCharacterData(button, state)
	if state == "up" then
		if source == tab.button[1] then
			local name = dgsGetText(tab.edit[1])
			if string.find(name, ' ') then
				name = string.gsub(name, ' ', '')
			end

			local surname = dgsGetText(tab.edit[2])
			if string.find(surname, ' ') then
				surname = string.gsub(surname, ' ', '')
			end

			local description = dgsGetText(tab.memo[1])

			local gender = dgsSwitchButtonGetText(tab.switch[1])
			if gender == 'Kobieta' then
				gender = 2
			else
				gender = 1
			end

			local height = dgsGetText(tab.edit[3])
			if string.len(height) < 3 then
				return
			end
			height = tonumber(height)

			local weight = dgsGetText(tab.edit[4])
			if string.len(weight) < 2 then
				return
			end
			weight = tonumber(weight)

			local age = dgsGetText(tab.edit[5])
			if string.len(age) < 2 then
				return
			end
			age = tonumber(age)

			local skin = getElementModel(character)

			local classSelected = dgsComboBoxGetSelectedItem(tab.comboBox[3])
			if classSelected == -1 or classSelected == nil or classSelected == false then
				return 
			end
			local class = dgsComboBoxGetItemText(tab.comboBox[3], classSelected)

			if type(height) == 'number' and type(weight) == 'number' and type(age) == 'number' then
				destroyCharacterCreatingPanel()

				triggerServerEvent("accounts:createNewCharacter", localPlayer, {name, surname, description, gender, height, weight, age, skin, class})
			end
		elseif source == tab.button[2] then
			destroyCharacterCreatingPanel()

			triggerServerEvent("accounts:characterList", localPlayer)
		end
	end
end

addEvent("accounts:newCharacter", true)
addEventHandler("accounts:newCharacter", root, function()
	destroyLoginPanel()
	fadeCamera(false)

	setTimer(function()
		makeNewCharacter()
		setCameraMatrix(848.95791748047, -1965.9711425781, 13.5, 750, 0, -300, 0, 0)

		addEventHandler("onClientRender", root, renderNewCharacter)

		fadeCamera(true)

		addEventHandler("onDgsComboBoxSelect", getRootElement(), onSelected)
		addEventHandler("onDgsMouseClick", root, getCharacterData)
	end, 1000, 1)
end)

function renderNewCharacter()
	if dgsSwitchButtonGetState(tab.switch[1]) == true then
		dgsSetVisible(tab.comboBox[2], true)
		dgsSetEnabled(tab.comboBox[2], true)
		dgsSetVisible(tab.comboBox[1], false)
		dgsSetEnabled(tab.comboBox[1], false)
	else
		dgsSetVisible(tab.comboBox[2], false)
		dgsSetEnabled(tab.comboBox[2], false)
		dgsSetVisible(tab.comboBox[1], true)
		dgsSetEnabled(tab.comboBox[1], true)
	end
end