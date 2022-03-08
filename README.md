# qb-flowerjob
This script is made for QBCore
Script uses 0.04 on resmon (sometimes lower)


Based off of qb-weedpicking

Author - DopeMan
https://github.com/MrEvilGamer/qb-weedpicking

!IMPORTANT!

Make sure to add these in qb-core/client/functions.lua


(And this after Drawtext3d) 

```lua
QBCore.Functions.Draw2DText = function(x, y, text, scale)
    SetTextFont(4)
    SetTextProportional(7)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextDropShadow()
    SetTextEdge(4, 0, 0, 0, 255)
    SetTextOutline()
    SetTextCentre(true)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end
```



(This at the Bottom)

```lua
QBCore.Functions.SpawnObject = function(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, true, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end
```
```lua
QBCore.Functions.SpawnLocalObject = function(model, coords, cb)
    local model = (type(model) == 'number' and model or GetHashKey(model))

    Citizen.CreateThread(function()
        RequestModel(model)
        local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
        SetModelAsNoLongerNeeded(model)

        if cb then
            cb(obj)
        end
    end)
end
```
```lua
QBCore.Functions.DeleteObject = function(object)
    SetEntityAsMissionEntity(object, false, true)
    DeleteObject(object)
end
```



ADD THIS TO YOUR qb-shops/config.lua file!

```lua
    ["flowerstore"] = {
        [1] = {
            name = "flower_paper",
            price = 50,
            amount = 50,
            info = {},
            type = "item",
            slot = 1,
        },
    },
        ["flowerstore"] = {
        ["label"] = "Flower Store",
        ["coords"] = {
            [1] = vector3(1559.65, 2179.06, 78.82),
            [2] = vector3(1559.65, 2179.06, 78.82)
        },
        ["products"] = Config.Products["flowerstore"],
        ["showblip"] = false,
        ["blipsprite"] = 52
    },
    
    ```
    
    
