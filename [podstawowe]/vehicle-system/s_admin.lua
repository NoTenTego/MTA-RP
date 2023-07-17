mysql = exports.mysql

addEvent("vehicle-system:getVehlibData", true)
addEventHandler("vehicle-system:getVehlibData", root, function(thePlayer)
    local query = mysql:query(true, "SELECT * from vehicles_shop")
    local vehlib = query[1]
    if not vehlib then
        return
    end

    triggerClientEvent(thePlayer, "vehicle-system:openVehlib", thePlayer, vehlib)
end)