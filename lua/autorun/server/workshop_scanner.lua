--[[
	This file forces clients to download mounted workshop addons
	that include custom content required by the client.

	Many addons will likely be ignored, thus decreasing initial client load time.

	The current map and gamemode are automatically downloaded to the client
	and are ignored by this script (provided they are workshop addons).
]]

print("Scanning mounted addons for custom content...")

-- From https://github.com/Facepunch/gmad/blob/master/include/AddonWhiteList.h
local supportedNames = {
	"scenes/*",
	"particles/*",
	"resource/fonts/*",
	"scripts/vehicles/*",
	"resource/localization/*/*",
	"sound/*",
	"materials/*",
	"models/*",
}

local function exists(name, path)
	local _, folders = file.Find(name, path)

	for _ in ipairs(folders) do
		return true
	end

	return false
end

--[[
	Returns true if the specified addon contains custom content and is not a map.

	The current map and gamemode are already automatically downloaded to clients.
]]
local function shouldDownload(addon)
	local title = addon.title

	if exists("maps/*", title) then
		return false
	end

	for _, name in ipairs(supportedNames) do
		if exists(name, title) then
			return true
		end
	end

	return false
end

for _, addon in pairs(engine.GetAddons()) do
	if addon.mounted and shouldDownload(addon) then
		print("\t[Workshop] Adding "..addon.title.." ("..addon.wsid..")")
		resource.AddWorkshop(addon.wsid)
	end
end

print("Clients will now download the above addons.")