local mysql = exports.mysql

local function isValidEmail(email)
	local emailPattern = "^[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?$"
	return string.match(email, emailPattern) ~= nil
end

addEvent("accounts:registerAccount", true)
addEventHandler("accounts:registerAccount", root, function(username, email, password, confirmPassword)
	if not username or username == "" or not password or password == "" or not confirmPassword or confirmPassword == "" then
		triggerClientEvent(client, "accounts:notification", client, "Wypełnij wszystkie pola.")
		return
	end
	if string.len(username) < 3 then
		triggerClientEvent(client, "accounts:notification", client, "Nazwa uzytkownika musi posiadać 3 znaki lub więcej.")
		return
	end
	if string.len(username) >= 19 then
		triggerClientEvent(client, "accounts:notification", client, "Nazwa użytkownika musi zawierać mniej niż 20 znaków.")
		return
	end
	if not isValidEmail(email) then
		triggerClientEvent(client, "accounts:notification", client, "Email jest nieprawidłowy.")
		return
	end
	if string.find(password, "'") or string.find(password, '"') then
		triggerClientEvent(client, "accounts:notification", client, "Hasło nie może zawierać ' oraz ''")
		return
	end
	if string.len(password) < 8 then
		triggerClientEvent(client, "accounts:notification", client, "Hasło musi zawierać minimalnie 8 znaków.")
		return
	end
	if string.len(password) > 50 then
		triggerClientEvent(client, "accounts:notification", client, "Hasło musi zawierać mniej niż 50 znaków")
		return
	end
	if password ~= confirmPassword then
		triggerClientEvent(client, "accounts:notification", client, "Hasła nie pasują do siebie!")
		return
	end
	if string.match(username,"%W") then
		triggerClientEvent(client, "accounts:notification", client, "Znaki \"!@#$\"%'^&*()\" nie są dozwolone do nazwy użytkownika.")
		return
    end
	local query = mysql:query(true, "SELECT username FROM accounts WHERE username = '"..username.."'")
    if query[1] then
        triggerClientEvent(client, "accounts:notification", client, "Już istnieje konto o podanym loginie!")
        return
    end

    local encryptionRule = tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))..tostring(math.random(0,9))
	local encryptedPW = string.lower(md5(string.lower(md5(password))..encryptionRule))
    local ipAddress = getPlayerIP(client)

    mysql:execute(true, "INSERT INTO accounts SET username='"..username.."', email='"..email.."', password='"..encryptedPW.."', salt='"..encryptionRule.."', ip='"..ipAddress.."'")
    triggerClientEvent(client, "accounts:notification", client, "Pomyślnie utworzono konto!")
end)

addEvent("accounts:verifyLogin", true)
addEventHandler("accounts:verifyLogin", root, function(username, password)
	local row = mysql:query(true, "SELECT id, salt, password, admin_level, support_level FROM `accounts` WHERE `username` = '"..username.."'")
	if not row[1] then
		return
	end
	
	local encryptionRule = row[1]["salt"]
	local encryptedPW = string.lower(md5(string.lower(md5(password))..encryptionRule))
	if encryptedPW == row[1]["password"] then
		for k, v in ipairs(getElementsByType("player")) do
			if getElementData(v, "dbid") == tonumber(dbid) then
				kickPlayer(v, v, "To konto jest aktualnie używane..")
				break
			end
		end

		setElementData(client, 'accountID', tonumber(row[1]["id"]))
		setElementData(client, 'username', username)
		setElementData(client, 'admin_level', tonumber(row[1]["admin_level"]) or 0)
		setElementData(client, 'support_level', tonumber(row[1]["support_level"] or 0))
		setElementDimension(client, tonumber(row[1]["id"]))
		
		characterList()
	else
		triggerClientEvent(client, "accounts:notification", client, "Wprowadzone dane są nieprawidłowe.")
	end
end)