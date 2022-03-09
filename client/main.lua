local QBCore = exports['qb-core']:GetCoreObject()

function DeleteObject()
    QBCore.Functions.DeleteObject = function(object)
        SetEntityAsMissionEntity()
        DeleteObject(object)
    end
end

isLoggedIn = true

local menuOpen = false
local wasOpen = false
local spawnedFlowers = 0
local flowerPlants = {}

local isPickingUp, isProcessing, isProcessing2 = false, false, false

RegisterNetEvent("QBCore:Client:OnPlayerLoaded", function()
	CheckCoords()
	Wait(1000)
	local coords = GetEntityCoords(PlayerPedId())
	if GetDistanceBetweenCoords(coords, Config.CircleZones.flowerField.coords, true) < 1000 then
		spawnFlowersPlants()
	end
end)

function CheckCoords()
	CreateThread(function()
		while true do
			local coords = GetEntityCoords(PlayerPedId())
			if GetDistanceBetweenCoords(coords, Config.CircleZones.flowerField.coords, true) < 1000 then
				spawnFlowersPlants()
			end
			Wait(1 * 60000)
		end
	end)
end

AddEventHandler('onResourceStart', function(resource)
	if resource == GetCurrentResourceName() then
		CheckCoords()
	end
end)

CreateThread(function()--flowers
	while true do
		Wait(10)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID


		for i=1, #flowerPlants, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(flowerPlants[i]), false) < 1 then
				nearbyObject, nearbyID = flowerPlants[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				QBCore.Functions.Draw2DText(0.5, 0.88, 'Press ~g~[E]~w~ to pickup Flowers', 0.4)
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)
				QBCore.Functions.Progressbar("search_register", "Picking up Flowers..", 3000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
					disableInventory = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(PlayerPedId())
					DeleteObject(nearbyObject)

					table.remove(flowerPlants, nearbyID)
					spawnedFlowers = spawnedFlowers - 1

					TriggerServerEvent('qb-flowerjob:pickedUpflower')
				end, function()
					ClearPedTasks(PlayerPedId())
				end)

				isPickingUp = false
			end
		else
			Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(flowerPlants) do
			DeleteObject()
		end
	end
end)
function spawnFlowersPlants()
	while spawnedFlowers < 20 do
		Wait(1)
		local flowerCoords = GenerateflowerCoords()

		QBCore.Functions.SpawnLocalObject('apa_mp_h_acc_vase_flowers_01', flowerCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)


			table.insert(flowerPlants, obj)
			spawnedFlowers = spawnedFlowers + 1
		end)
	end
	Wait(45 * 60000)
end

function ValidateflowerCoord(plantCoord)
	if spawnedFlowers > 0 then
		local validate = true

		for k, v in pairs(flowerPlants) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.flowerField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateflowerCoords()
	while true do
		Wait(1)

		local flowerCoordX, flowerCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-10, 10)

		Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-10, 10)

		flowerCoordX = Config.CircleZones.flowerField.coords.x + modX
		flowerCoordY = Config.CircleZones.flowerField.coords.y + modY

		local coordZ = GetCoordZflower(flowerCoordX, flowerCoordY)
		local coord = vector3(flowerCoordX, flowerCoordY, coordZ)

		if ValidateflowerCoord(coord) then
			return coord
		end
	end
end

function GetCoordZflower(x, y)
	local groundCheckHeights = { 70.0, 71.0, 72.0, 73.0, 74.0, 75.0, 76.0, 77.0, 78.0, 79.0, 80.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 31.85
end

CreateThread(function()
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.flowerProcessing.coords, true) < 5 then
			DrawMarker(2, Config.CircleZones.flowerProcessing.coords.x, Config.CircleZones.flowerProcessing.coords.y, Config.CircleZones.flowerProcessing.coords.z - 0.2 , 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.15, 255, 0, 0, 100, 0, 0, 0, true, 0, 0, 0)


			if not isProcessing and GetDistanceBetweenCoords(coords, Config.CircleZones.flowerProcessing.coords, true) <1 then
				QBCore.Functions.DrawText3D(Config.CircleZones.flowerProcessing.coords.x, Config.CircleZones.flowerProcessing.coords.y, Config.CircleZones.flowerProcessing.coords.z, 'Press ~g~[E]~w~ to Process')
			end

			if IsControlJustReleased(0, 38) and not isProcessing then
				local hasBag = false
				local s1 = false
				local hasflower = false
				local s2 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasflower = result
					s1 = true
				end, 'rose_flower')

				while(not s1) do
					Wait(100)
				end
				Wait(100)
				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasBag = result
					s2 = true
				end, 'flower_paper')

				while(not s2) do
					Wait(100)
				end

				if (hasflower and hasBag) then
					Processflower()
				elseif (hasflower) then
					QBCore.Functions.Notify('You dont have enough Flower Paper.', 'error')
				elseif (hasBag) then
					QBCore.Functions.Notify('You dont have enough flowers.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough flowers and flower papers', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function Processflower()
	isProcessing = true
	local playerPed = PlayerPedId()

	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Process..", 30000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-flowerjob:processflower')

		local timeLeft = Config.Delays.FlowerProccesing / 1000

		while timeLeft > 0 do
			Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.flowerProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-flowerjob:cancelProcessing')
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing = false
end

CreateThread(function()
	while QBCore == nil do
		Wait(200)
	end
	while true do
		Wait(10)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.Gardener.coords, true) < 5 then
			DrawMarker(2, Config.CircleZones.Gardener.coords.x, Config.CircleZones.Gardener.coords.y, Config.CircleZones.Gardener.coords.z - 0.2 , 0, 0, 0, 0, 0, 0, 0.3, 0.2, 0.15, 255, 0, 0, 100, 0, 0, 0, true, 0, 0, 0)


			if not isProcessing2 and GetDistanceBetweenCoords(coords, Config.CircleZones.Gardener.coords, true) <1 then
				QBCore.Functions.DrawText3D(Config.CircleZones.Gardener.coords.x, Config.CircleZones.Gardener.coords.y, Config.CircleZones.Gardener.coords.z, 'Press ~g~[E]~w~ to sell your flowers')
			end

			if IsControlJustReleased(0, 38) and not isProcessing2 then
				local hasflower2 = false
				local hasBag2 = false
				local s3 = false

				QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
					hasflower2 = result
					hasBag2 = result
					s3 = true

				end, 'rose_bukey')

				while(not s3) do
					Wait(100)
				end


				if (hasflower2) then
					SellDrug()
				elseif (hasflower2) then
					QBCore.Functions.Notify('You dont have enough flower papers.', 'error')
				elseif (hasBag2) then
					QBCore.Functions.Notify('You dont have enough flowers.', 'error')
				else
					QBCore.Functions.Notify('You dont have enough flower bukeys to sell.', 'error')
				end
			end
		else
			Wait(500)
		end
	end
end)

function SellDrug()
	isProcessing2 = true
	local playerPed = PlayerPedId()

	--
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)
	SetEntityHeading(PlayerPedId(), 108.06254)

	QBCore.Functions.Progressbar("search_register", "Trying to Sell..", 1500, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
		disableInventory = true,
	}, {}, {}, {}, function()
	 TriggerServerEvent('qb-flowerjob:selld')

		local timeLeft = Config.Delays.flowerProcessing / 1000

		while timeLeft > 0 do
			Wait(500)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.flowerProcessing.coords, false) > 4 then
				break
			end
		end
		ClearPedTasks(PlayerPedId())
	end, function()
		ClearPedTasks(PlayerPedId())
	end) -- Cancel

	isProcessing2 = false
end

CreateThread(function()
    local flower = AddBlipForCoord(1580.86, 2165.03, 79.35)
    SetBlipSprite (flower, 197)
    SetBlipDisplay(flower, 4)
    SetBlipScale  (flower, 0.60)
    SetBlipAsShortRange(flower, false)
    SetBlipColour(flower, 3)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName("Flower Land")
    EndTextCommandSetBlipName(flower)
end)
