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

addEvent("vehicle-system:openVehlib", true)
addEventHandler("vehicle-system:openVehlib", root, function(vehlib)
    if isElement(tab.window[1]) then
        return
    end

    vehicles = vehlib
    addEventHandler('onDgsMouseClick', root, buttonFunctions)
    addEventHandler('onDgsGridListSelect', root, gridListSelection)
    showCursor(true)

    tab.window[1] = dgsCreateWindow(1/zoom, 1*py, 1000/zoom, 800*py, 'Zarządzanie pojazdami', false)
    dgsCenterElement(tab.window[1])
    dgsWindowSetSizable(tab.window[1], false)
end)