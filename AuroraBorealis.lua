local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

local CHECK_INTERVAL = 30
local hopping = false

-------------------------------------------------
-- EVENT CHECK
-------------------------------------------------
local function getEventsFolder()
	return player:WaitForChild("PlayerGui")
		:WaitForChild("Events")
		:WaitForChild("Frame")
		:WaitForChild("Events")
end

local function isEventActive(event)
	if event:IsA("GuiObject") and event.Visible then
		return true
	end

	for _, v in ipairs(event:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			if v.Text and v.Text ~= "" then
				return true
			end
		end
	end

	return false
end

local function isAuroraActive()
	local eventsFolder = getEventsFolder()

	for _, event in ipairs(eventsFolder:GetChildren()) do
		if isEventActive(event) then
			local name = event.Name
			if string.find(name, "Aurora Borealis") then
				return true
			end
		end
	end

	return false
end

-------------------------------------------------
-- SERVER FETCH (ONLY WHEN NEEDED)
-------------------------------------------------
local function getServers(cursor)
	local url =
		"https://games.roblox.com/v1/games/"
		.. placeId
		.. "/servers/Public?limit=100&sortOrder=Asc"

	if cursor then
		url = url .. "&cursor=" .. cursor
	end

	local success, result = pcall(function()
		return HttpService:JSONDecode(game:HttpGet(url))
	end)

	if success then
		return result
	end

	return nil
end

local function findServerWithAurora()

	local cursor = nil

	while true do
		local data = getServers(cursor)
		if not data then return nil end

		for _, server in ipairs(data.data) do
			if server.id ~= game.JobId and server.playing < server.maxPlayers then

				return server.id
			end
		end

		cursor = data.nextPageCursor
		if not cursor then
			break
		end
	end

	return nil
end

-------------------------------------------------
-- HOP
-------------------------------------------------
local function hop()
	if hopping then return end
	hopping = true

	print("🔎 Searching server with Aurora presence...")

	local serverId = findServerWithAurora()

	if serverId then
		print("🚀 Hopping:", serverId)
		TeleportService:TeleportToPlaceInstance(placeId, serverId, player)
	else
		print("❌ No server found, retry later")
		hopping = false
	end
end

-------------------------------------------------
-- MAIN LOOP (OPTIMIZED)
-------------------------------------------------
task.spawn(function()
	while true do
		task.wait(CHECK_INTERVAL)
		print("🔍 Checking Aurora event...")

		local ok, active = pcall(isAuroraActive)

		if ok and active then
			print("🌦 Aurora ACTIVE -> staying")
		else
			print("❌ Aurora NOT ACTIVE -> hopping")
			hop()
		end


	end
end)
