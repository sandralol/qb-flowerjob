Config = {}

Config.Locale = 'en'

Config.Delays = {
	flowerProcessing = 1000 * 2
}

Config.Pricesell = 750

Config.MinPiecesWed = 1

Config.GardenerItems = {
	flower_paper = 91
}

Config.LicenseEnable = false -- enable processing licenses? The player will be required to buy a license in order to process drugs. 

Config.GiveBlack = false -- give black money? if disabled it'll give regular cash.

Config.CircleZones = {
	flowerField = {coords = vector3(1580.86, 2165.03, 79.35), name = 'blip_weedfield', color = 25, sprite = 496, radius = 100.0},
	flowerProcessing = {coords = vector3(1557.56, 2162.28, 78.67), name = 'blip_weedprocessing', color = 25, sprite = 496, radius = 100.0},
	Gardener = {coords = vector3(1552.87, 2155.83, 78.9), name = 'blip_drugdealer', color = 6, sprite = 378, radius = 25.0},
}