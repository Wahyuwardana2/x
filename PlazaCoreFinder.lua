--================================================--
-- PLAZA SCANNER - IMPROVED VERSION
--================================================--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

--================================================--
-- EXTERNAL
--================================================--

local ExternalConfig = ...

if type(ExternalConfig) ~= "table" then
	ExternalConfig = {}
end

local RAPController

pcall(function()
	RAPController = require(
		ReplicatedStorage
			:WaitForChild("Controllers")
			:WaitForChild("Trading")
			:WaitForChild("RAPController")
	)
end)

--================================================--
-- CONFIG
--================================================--

local Config = {

	--================================================--
	-- WEBHOOK
	--================================================--

	Webhook = {},

	Debug = true,
	LoadDelay = 1,
	StayTime = 10,

	--================================================--
	-- ITEMS
	--================================================--

	Items = {

		--================================================--
		-- FISH
		--================================================--

		Fish = {
			Enabled = true,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Exact",

				List = {
					"pyrocoil",
					"stormshell brute",
					"wintertusk mammofin"
					-- "mr money bags"
					-- "cenobyte.exe"
				}
			},

			Mutation = {
				Enabled = false,
				Require = true,
				Mode = "Blacklist",
				Match = "Exact",
				List = {
					"Shiny"
				}
			},

			Price = {
				Enabled = false,
				Min = 1,
				Max = 196
			},

			RAP = {
				Enabled = true,
				Percent = 5
			}
		},

		--================================================--
		-- GEARS
		--================================================--

		Gears = {
			Enabled = true,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Contains",

				List = {
					"Withering Core"
				}
			},

			Mutation = {
				Enabled = false,
				Require = true,
				Mode = "Blacklist",
				Match = "Exact",

				List = {
					"ghost",
					"stone",
					"albino",
					"sandy"
				}
			},

			Price = {
				Enabled = false,
				Min = 1,
				Max = 48
			},

			RAP = {
				Enabled = true,
				Percent = 20
			}
		},

		--================================================--
		-- FISHING RODS
		--================================================--

		["Fishing Rods"] = {
			Enabled = true,

			Name = {
				Enabled = true,
				Mode = "Blacklist",
				Match = "Exact",

				List = {
					"empyrean staff"
				}
			},

			Price = {
				Enabled = false,
				Min = 1,
				Max = 100
			},

			RAP = {
				Enabled = true,
				Min = 100,
				Max = 100000,
				Percent = 1
			}
		},

		--================================================--
		-- PETS
		--================================================--

		Pets = {
			Enabled = true,

			Name = {
				Enabled = false,
				Mode = "Whitelist",
				Match = "Contains",

				List = {
					"Stellar Hedgehog"
				}
			},

			Price = {
				Enabled = false,
				Min = 1,
				Max = 300
			},

			RAP = {
				Enabled = true,
				Min = 100,
				Max = 100000,
				Percent = 2
			}
		},

		--================================================--
		-- BOATS
		--================================================--

		Boats = {
			Enabled = true,

			Name = {
				Enabled = false,
				Mode = "Blacklist",
				Match = "Exact",

				List = {
					"dinky fishing boat",
					"raft",
					"collosal pirate ship",
					"santa sled",
					"christmas car",
					"coral boat",
					"retro utility boat",
					"banana pirate raft",
					"classic ducky boat",
					"swan boat",
					"pumpkin boat",
					"ancient ship",
					"retro car boat",
					"ferryman boat",
					"superstar boat",
					"undersea racer"
				}
			},

			Price = {
				Enabled = false,
				Min = 1,
				Max = 100
			},

			RAP = {
				Enabled = true,
				Min = 100,
				Max = 100000,
				Percent = 1
			}
		},

		--================================================--
		-- EQUIPMENT
		--================================================--

		Equipment = {
			Enabled = false,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Exact",
				List = {}
			},

			Price = {
				Enabled = true,
				Min = 1,
				Max = 100
			},

			RAP = {
				Enabled = false,
				Percent = 1
			}
		},

		--================================================--
		-- TROPHIES
		--================================================--

		Trophies = {
			Enabled = false,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Exact",
				List = {}
			},

			Price = {
				Enabled = true,
				Min = 1,
				Max = 100
			},

			RAP = {
				Enabled = false,
				Percent = 1
			}
		},

		--================================================--
		-- ENCHANT STONES
		--================================================--

		["Enchant Stones"] = {
			Enabled = false,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Exact",
				List = {}
			},

			Price = {
				Enabled = true,
				Min = 1,
				Max = 100
			},

			RAP = {
				Enabled = false,
				Percent = 1
			}
		}
	},

	--================================================--
	-- SERVER
	--================================================--

	Server = {
		AutoHop = false,
		MinPlayer = 1,
		MaxPlayer = 20,
		HopDelay = 1
	}
}

--================================================--
-- MERGE EXTERNAL CONFIG (IMPROVED)
--================================================--

local function MergeTable(target, source)
	if type(source) ~= "table" then
		return
	end
	
	for k, v in pairs(source) do
		if type(v) == "table" and type(target[k]) == "table" then
			MergeTable(target[k], v)
		else
			target[k] = v
		end
	end
end

if type(ExternalConfig.Webhook) == "table" then
	Config.Webhook = ExternalConfig.Webhook
end

if type(ExternalConfig.Debug) == "boolean" then
	Config.Debug = ExternalConfig.Debug
end

if tonumber(ExternalConfig.LoadDelay) then
	Config.LoadDelay = ExternalConfig.LoadDelay
end

if tonumber(ExternalConfig.StayTime) then
	Config.StayTime = ExternalConfig.StayTime
end

if type(ExternalConfig.Items) == "table" then
	MergeTable(Config.Items, ExternalConfig.Items)
end

if type(ExternalConfig.Server) == "table" then
	MergeTable(Config.Server, ExternalConfig.Server)
end

--================================================--
-- STATE MANAGEMENT
--================================================--

local State = {
	FoundItems = {},
	UsedUUID = {},
	FoundCount = 0,
	HopAttempts = 0,
	IsRunning = false
}

local MAX_HOP_ATTEMPTS = 5
local ServerCacheFile = "JP_FINDER_V7_2_SERVERS.json"
local ServerList = {}
local TriedServers = {}

--================================================--
-- LOGGER
--================================================--

local function Log(...)
	if Config.Debug then
		print(...)
	end
end

local function Warn(...)
	warn(...)
end

--================================================--
-- SAFE ATTRIBUTE ACCESS
--================================================--

local function SafeGetAttribute(obj, name, default)
	if not obj or not obj.GetAttribute then
		return default or nil
	end
	
	local ok, result = pcall(function()
		return obj:GetAttribute(name)
	end)
	
	return ok and result or (default or nil)
end

--================================================--
-- CLEAN / NORMALIZE
--================================================--

local function Clean(value)
	if value == nil then
		return ""
	end

	local text = tostring(value)
	text = text:lower()
	text = text:gsub("%s+", " ")
	text = text:match("^%s*(.-)%s*$")

	return text
end

--================================================--
-- CATEGORY & WEBHOOK HELPERS
--================================================--

local function GetCategory(itemType)
	return Config.Items[itemType]
end

local function GetWebhook(itemType)
	local webhook = Config.Webhook[itemType]

	if type(webhook) ~= "string" then
		return nil
	end

	if webhook == "" then
		return nil
	end

	return webhook
end

--================================================--
-- TIME
--================================================--

local function GetWIBTime()
	return os.date(
		"!%d/%m/%Y %H:%M:%S",
		os.time() + 7 * 60 * 60
	) .. " WIB"
end

--================================================--
-- CLEAN RAP NAME
--================================================--

local function CleanRAPName(name)
	local result = tostring(name or "")

	for _, prefix in ipairs({
		"Big Shiny ",
		"Big ",
		"Shiny "
	}) do
		result = result:gsub("^" .. prefix, "")
	end

	return result
end

--================================================--
-- RAP (IMPROVED LOGGING)
--================================================--

local function GetRAP(itemType, itemName, item)
	if not RAPController then
		Log("[RAP] CONTROLLER NIL")
		return nil
	end

	local ok, rap = pcall(function()
		if itemType == "Pets" and item.ItemId then
			return RAPController:GetRAP("Pets", item.ItemId)
		end

		if item.ItemId then
			local result = RAPController:GetRAP(itemType, item.ItemId)
			if result then
				return result
			end
		end

		return RAPController:GetRAP(
			itemType,
			CleanRAPName(item.BaseName or itemName)
		)
	end)

	if not ok then
		Log("[RAP ERROR]", itemType, itemName, item.ItemId, rap)
	end

	return ok and rap or nil
end

--================================================--
-- NAME FILTER
--================================================--

local function CheckFilter(value, cfg)
	if not cfg or not cfg.Enabled then
		return true
	end

	if #(cfg.List or {}) == 0 then
		if cfg.Mode == "Whitelist" then
			return false
		end
		return true
	end

	value = Clean(value)
	local found = false

	for _, v in ipairs(cfg.List) do
		local text = Clean(v)

		if text ~= "" then
			if cfg.Match == "Exact" then
				found = value == text
			elseif cfg.Match == "Contains" then
				found = value:find(text, 1, true) ~= nil
			elseif cfg.Match == "StartsWith" then
				found = value:sub(1, #text) == text
			elseif cfg.Match == "EndsWith" then
				found = value:sub(-#text) == text
			end
		end

		if found then
			break
		end
	end

	if cfg.Mode == "Blacklist" then
		return not found
	elseif cfg.Mode == "Whitelist" then
		return found
	end

	return true
end

--================================================--
-- MUTATION FILTER
--================================================--

local function CheckMutation(mutation, cfg)
	if not cfg or not cfg.Enabled then
		return true
	end

	mutation = Clean(mutation)

	if cfg.Require and (mutation == "" or mutation == "normal" or mutation == "nill") then
		return false
	end

	for _, bad in ipairs(cfg.List or {}) do
		local target = Clean(bad)
		local matched = false

		if cfg.Match == "Exact" then
			matched = mutation == target
		elseif cfg.Match == "Contains" then
			matched = mutation:find(target, 1, true) ~= nil
		elseif cfg.Match == "StartsWith" then
			matched = mutation:sub(1, #target) == target
		elseif cfg.Match == "EndsWith" then
			matched = mutation:sub(-#target) == target
		end

		if matched then
			if cfg.Mode == "Blacklist" then
				return false
			end
			if cfg.Mode == "Whitelist" then
				return true
			end
		end
	end

	if cfg.Mode == "Whitelist" then
		return false
	end

	return true
end

--================================================--
-- PRICE
--================================================--

local function CheckPrice(item)
	local category = GetCategory(item.ItemType)
	local cfg = category and category.Price

	if not cfg or not cfg.Enabled then
		return true
	end

	local price = tonumber(item.Price) or 0

	if cfg.Min and price < cfg.Min then
		Log("[PRICE TOO LOW]", item.Name, price)
		return false
	end

	if cfg.Max and price > cfg.Max then
		Log("[PRICE TOO HIGH]", item.Name, price)
		return false
	end

	return true
end

--================================================--
-- RAP FILTER + DISPLAY
--================================================--

local function CheckRAP(item)
	local category = GetCategory(item.ItemType)
	local cfg = category and category.RAP

	-- Tetap ambil RAP walaupun filter OFF
	local rap = GetRAP(item.ItemType, item.Name, item)

	if rap then
		item.RAP = rap
	end

	-- RAP OFF = tidak memfilter
	if not cfg or not cfg.Enabled then
		return true
	end

	-- RAP tidak ditemukan = tetap lolos
	if not rap then
		return true
	end

	if cfg.Min and rap < cfg.Min then
		Log("[RAP TOO LOW]", item.Name, "RAP:", rap, "MIN:", cfg.Min)
		return false
	end

	if cfg.Max and rap > cfg.Max then
		Log("[RAP TOO HIGH]", item.Name, "RAP:", rap, "MAX:", cfg.Max)
		return false
	end

	if cfg.Percent ~= nil then
		local percent = tonumber(cfg.Percent) or 0
		local limit = rap * (100 - percent) / 100

		if item.Price > limit then
			Log(
				"[OVER RAP LIMIT]",
				item.Name,
				"PRICE:", item.Price,
				"RAP:", rap,
				"REQUIRED:", percent .. "%",
				"MAX PRICE:", limit
			)
			return false
		end

		if rap > 0 then
			item.UnderRap = math.floor((1 - item.Price / rap) * 100)
		end
	end

	return true
end

--================================================--
-- CATEGORY FILTER
--================================================--

local function CheckCategory(item)
	local category = GetCategory(item.ItemType)

	if not category then
		Log("[UNKNOWN TYPE]", item.ItemType)
		return false
	end

	if not category.Enabled then
		return false
	end

	-- NAME CHECK
	if category.Name then
		local name = (item.BaseName and item.BaseName ~= "") and item.BaseName or item.Name
		local result = CheckFilter(name, category.Name)

		Log(
			"[NAME CHECK]",
			"Type:", item.ItemType,
			"Display:", item.Name,
			"Base:", item.BaseName,
			"Clean:", Clean(name),
			"Mode:", category.Name.Mode,
			"Match:", category.Name.Match,
			"Result:", result
		)

		if not result then
			Log("[NAME FAIL]", item.Name, "BASE:", item.BaseName)
			return false
		end
	elseif category.FilterName then
		Log("[NAME FAIL]", item.Name)
		return false
	end

	-- VARIANT CHECK
	if category.Variant and not CheckFilter(item.Variant, category.Variant) then
		Log("[VARIANT FAIL]", item.Name, item.Variant)
		return false
	end

	-- SIZE CHECK
	if category.Size and not CheckFilter(item.Size, category.Size) then
		Log("[SIZE FAIL]", item.Name, item.Size)
		return false
	end

	return true
end

--================================================--
-- UI HELPERS
--================================================--

local function GetText(obj)
	if not obj then
		return ""
	end

	if obj:IsA("TextLabel") or obj:IsA("TextButton") then
		return obj.Text or ""
	end

	return ""
end

local function GetImage(frame)
	local image

	pcall(function()
		image = frame:FindFirstChildWhichIsA("ImageLabel", true)
	end)

	if image and image.Image then
		return image.Image:gsub("rbxassetid://", "")
	end

	return nil
end

--================================================--
-- ITEM PARSER
--================================================--

local function ParseItemDetail(item, inside)
	item.BaseName = item.Name
	item.Size = ""

	-- SIZE
	local bigFrame = inside:FindFirstChild("BigFrame", true)
	if bigFrame and bigFrame.Visible then
		local label = bigFrame:FindFirstChild("Label", true)
		item.Size = (label and label.Text) or "Big"
	end

	-- MUTATION
	local mutation = inside:FindFirstChild("VariantLabel", true)
	if mutation and mutation.Visible then
		local text = GetText(mutation)
		if text ~= "" then
			item.Mutation = text
		end
	end

	-- VARIANT
	local shiny = inside:FindFirstChild("ShinyFrame", true)
	if shiny and shiny.Visible then
		local label = shiny:FindFirstChild("Label", true)
		if label then
			item.Variant = label.Text
		end
	end

	-- PREFIX HANDLING
	local name = item.Name
	local lower = name:lower()

	if lower:find("^big shiny ") then
		if item.Size == "" then
			item.Size = "Big"
		end
		if item.Mutation == "" then
			item.Mutation = "Shiny"
		end
		item.BaseName = name:gsub("^[Bb][Ii][Gg]%s+[Ss][Hh][Ii][Nn][Yy]%s+", "")
	elseif lower:find("^big ") then
		if item.Size == "" then
			item.Size = "Big"
		end
		item.BaseName = name:gsub("^[Bb][Ii][Gg]%s+", "")
	elseif lower:find("^shiny ") then
		if item.Mutation == "" then
			item.Mutation = "Shiny"
		end
		item.BaseName = name:gsub("^[Ss][Hh][Ii][Nn][Yy]%s+", "")
	end
end

--================================================--
-- WEIGHT
--================================================--

local function GetWeight(item, inside)
	if item.ItemType ~= "Fish" then
		return ""
	end

	local frame = inside:FindFirstChild("WeightFrame", true)
	if not frame or not frame.Visible then
		return "-"
	end

	local label = frame:FindFirstChild("Label", true)
	if label then
		return label.Text
	end

	local text = frame:FindFirstChildWhichIsA("TextLabel", true)
	return (text and text.Text) or "-"
end

--================================================--
-- ORIGINAL NAME
--================================================--

local function GetOriginalName(itemType, itemId)
	if not itemId or not RAPController then
		return nil
	end

	local ok, result = pcall(function()
		return RAPController:GetItemName(itemType, itemId)
	end)

	return ok and result or nil
end

--================================================--
-- SELLER
--================================================--

local function GetSeller(userId)
	if not userId then
		return "Unknown"
	end

	local ok, name = pcall(function()
		return Players:GetNameFromUserIdAsync(userId)
	end)

	return ok and name or tostring(userId)
end

--================================================--
-- CHECK ITEM (IMPROVED WITH SAFE ACCESS)
--================================================--

local function CheckItem(frame, booth)
	local uuid = SafeGetAttribute(frame, "ItemUUID")

	if uuid and State.UsedUUID[uuid] then
		return
	end

	local inside = frame:FindFirstChild("Inside")
	if not inside then
		return
	end

	local buy = frame:FindFirstChild("Buy")

	local item = {
		ItemUUID = uuid,
		ItemType = SafeGetAttribute(frame, "ItemType"),
		ItemId = SafeGetAttribute(frame, "ItemId"),
		RawName = "",
		Image = GetImage(frame),
		Name = "",
		BaseName = "",
		Variant = "",
		Mutation = "",
		Size = "",
		Weight = "",
		Price = buy and SafeGetAttribute(buy, "LastKnownPrice", 0) or 0,
		RAP = nil,
		UnderRap = nil
	}

	-- NAME
	local label = inside:FindFirstChild("Label", true)
	if label then
		item.Name = GetText(label)
	end

	if item.Name == "" then
		return
	end

	-- PARSE
	ParseItemDetail(item, inside)

	-- PET ORIGINAL NAME
	if item.ItemType == "Pets" then
		local original = GetOriginalName(item.ItemType, item.ItemId)
		if original then
			item.RawName = original
			Log("[PET NAME DEBUG]", item.Name, item.ItemId, item.RawName)
		else
			item.RawName = item.BaseName
		end
	end

	-- WEIGHT
	item.Weight = GetWeight(item, inside)

	-- CATEGORY FILTER
	if not CheckCategory(item) then
		return
	end

	local category = GetCategory(item.ItemType)

	-- MUTATION
	if category and category.Mutation and not CheckMutation(item.Mutation, category.Mutation) then
		Log("[MUTATION FAIL]", item.Name, item.Mutation)
		return
	end

	-- PRICE
	if not CheckPrice(item) then
		return
	end

	-- RAP
	if not CheckRAP(item) then
		return
	end

	-- SELLER
	item.Seller = GetSeller(SafeGetAttribute(booth, "Owner"))

	-- UUID
	if uuid then
		State.UsedUUID[uuid] = true
	end

	table.insert(State.FoundItems, item)
	State.FoundCount += 1

	-- DEBUG OUTPUT (ONLY IN DEBUG MODE)
	if Config.Debug then
		print("================")
		print("FOUND", item.Name)
		print("TYPE", item.ItemType)
		print("BASE", item.BaseName)
		print("VARIANT", item.Variant)
		print("MUTATION", item.Mutation)
		print("SIZE", item.Size)
		print("WEIGHT", item.Weight)
		print("PRICE", item.Price)
		print("RAP", item.RAP)
		print("================")
	end
end

--================================================--
-- SCAN BOOTHS
--================================================--

local function ScanBooths()
	local islands = workspace:FindFirstChild("Islands")
	if not islands then
		return
	end

	local trade = islands:FindFirstChild("TradePlaza", true)
	if not trade then
		return
	end

	local booths = trade:FindFirstChild("Booths")
	if not booths then
		return
	end

	for _, booth in ipairs(booths:GetChildren()) do
		local plane = booth:FindFirstChild("Plane")
		if plane then
			local gui = plane:FindFirstChild("SurfaceGui")
			if gui then
				local items = gui:FindFirstChild("Items")
				if items then
					for _, frame in ipairs(items:GetChildren()) do
						if frame:IsA("Frame") then
							CheckItem(frame, booth)
						end
					end
				end
			end
		end
	end
end

--================================================--
-- ITEM TEXT BUILDER (IMPROVED)
--================================================--

local function BuildItemText(item)
	local parts = {
		"━━━━━━━━━━━━━━\n\n",
		"🎣 ***`" .. tostring(item.Name or "-") .. "`***\n\n",
		"**Seller**\n" .. tostring(item.Seller or "-") .. "\n\n",
		"Type : " .. tostring(item.ItemType or "-") .. "\n\n"
	}

	if item.Variant and item.Variant ~= "" then
		table.insert(parts, "Variant : " .. item.Variant .. "\n")
	end

	if item.Mutation and item.Mutation ~= "" then
		table.insert(parts, "Mutation : ***`" .. item.Mutation .. "`***\n")
	end

	if item.Size and item.Size ~= "" then
		table.insert(parts, "Size : " .. item.Size .. "\n")
	end

	if item.Weight and item.Weight ~= "" and item.Weight ~= "-" then
		table.insert(parts, "Weight : " .. item.Weight .. "\n")
	end

	table.insert(parts, "\nPrice : ***`" .. tostring(item.Price or 0) .. "`***\n")
	table.insert(parts, "RAP : " .. tostring(item.RAP or "-") .. "\n")

	if item.UnderRap then
		table.insert(parts, "Under RAP : ***`" .. tostring(item.UnderRap) .. "%`***\n")
	end

	return table.concat(parts) .. "\n"
end

--================================================--
-- WEBHOOK (IMPROVED)
--================================================--

local function SendWebhook(items)
	local grouped = {}

	-- GROUP BY WEBHOOK
	for _, item in ipairs(items) do
		local webhook = GetWebhook(item.ItemType)
		if webhook then
			grouped[webhook] = grouped[webhook] or {}
			table.insert(grouped[webhook], item)
		end
	end

	-- NO WEBHOOK
	if next(grouped) == nil then
		Warn("[WEBHOOK] NO WEBHOOK CONFIGURED")
		return
	end

	-- REQUEST FUNCTION
	local req = request or http_request or (syn and syn.request)

	if not req then
		Warn("[WEBHOOK] REQUEST FUNCTION NOT FOUND")
		return
	end

	-- SEND BATCHES
	local BATCH_SIZE = 4
	local MAX_TEXT = 900

	for webhook, list in pairs(grouped) do
		local batch = {}
		local batchText = ""

		local function SendBatch()
			if #batch == 0 then
				return
			end

			local jobId = game.JobId
			local joinLink = "https://www.roblox.com/games/start?placeId=" ..
				game.PlaceId .. "&gameInstanceId=" .. jobId

			local payload = {
				username = "PLAZA SCANNER BOT",
				avatar_url = "https://raw.githubusercontent.com/Wahyuwardana2/x/refs/heads/main/FindMe.png",
				embeds = {{
					title = "🎣 PLAZA SCANNER FOUND (" .. #batch .. " ITEMS)",
					color = 65280,
					fields = {
						{
							name = "Server",
							value = #Players:GetPlayers() .. "/" .. Players.MaxPlayers,
							inline = false
						},
						{
							name = "JobId",
							value = "📋 Copy mobile:\n`" .. jobId .. "`\n\n" ..
								"📋 Copy desktop:\n```" .. jobId .. "```",
							inline = false
						},
						{
							name = "Join Server",
							value = "🔗 " .. joinLink,
							inline = false
						},
						{
							name = "Items",
							value = batchText,
							inline = false
						}
					},
					footer = {
						text = "PLAZA SCANNER | " .. game.JobId .. " | " .. GetWIBTime()
					}
				}}
			}

			local ok, err = pcall(function()
				req({
					Url = webhook,
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = HttpService:JSONEncode(payload)
				})
			end)

			if ok then
				Log("[WEBHOOK SENT]", #batch, webhook)
			else
				Warn("[WEBHOOK ERROR]", err)
			end
		end

		for _, item in ipairs(list) do
			local add = BuildItemText(item)

			if #batch >= BATCH_SIZE or (#batch > 0 and #batchText + #add > MAX_TEXT) then
				SendBatch()
				table.clear(batch)
				batchText = ""
				task.wait(0.5)
			end

			table.insert(batch, item)
			batchText ..= add
		end

		SendBatch()
	end
end

--================================================--
-- SERVER CACHE
--================================================--

local function SaveServerCache()
	if not writefile then
		return
	end

	pcall(function()
		writefile(
			ServerCacheFile,
			HttpService:JSONEncode({
				Servers = ServerList,
				Tried = TriedServers
			})
		)
	end)
end

local function LoadServerCache()
	if not readfile or not isfile then
		return
	end

	if not isfile(ServerCacheFile) then
		return
	end

	local ok, data = pcall(function()
		return HttpService:JSONDecode(readfile(ServerCacheFile))
	end)

	if ok and data then
		ServerList = data.Servers or {}
		TriedServers = data.Tried or {}
		Log("[CACHE LOADED]", #ServerList)
	end
end

local function IsServerUsed(id)
	return TriedServers[id] == true
end

--================================================--
-- GET ALL SERVERS (IMPROVED WITH DEDUPLICATION)
--================================================--

local function GetAllServers()
	local servers = {}
	local cursor = ""
	local page = 1
	local seenServers = {}

	while true do
		local url = "https://games.roblox.com/v1/games/" ..
			tostring(PlaceId) ..
			"/servers/Public?sortOrder=Desc&limit=100"

		if cursor ~= "" then
			url = url .. "&cursor=" .. HttpService:UrlEncode(cursor)
		end

		local success, response = pcall(function()
			return game:HttpGet(url)
		end)

		if not success then
			Warn("[SERVER API ERROR]", response)
			break
		end

		local decodeSuccess, data = pcall(function()
			return HttpService:JSONDecode(response)
		end)

		if not decodeSuccess or not data then
			Warn("[SERVER JSON ERROR]")
			break
		end

		if data.data then
			for _, server in ipairs(data.data) do
				if server.id and not seenServers[server.id] then
					seenServers[server.id] = true
					if server.id ~= game.JobId
						and server.playing >= Config.Server.MinPlayer
						and server.playing <= Config.Server.MaxPlayer
						and not IsServerUsed(server.id)
					then
						table.insert(servers, server.id)
					end
				end
			end
		end

		Log("[SERVER PAGE]", page, "| FOUND:", #servers)

		if not data.nextPageCursor then
			break
		end

		-- Prevent infinite loop on repeated cursor
		if seenServers[data.nextPageCursor] then
			Warn("[SERVER API] Repeated cursor detected")
			break
		end

		cursor = data.nextPageCursor
		page += 1
		task.wait(0.5)
	end

	Log("[SERVER FOUND]", #servers)
	return servers
end

--================================================--
-- NEXT SERVER
--================================================--

local function GetNextServer()
	if #ServerList == 0 then
		ServerList = GetAllServers()
	end

	if #ServerList == 0 then
		Log("[RESET SERVER CACHE]")
		TriedServers = {}
		ServerList = GetAllServers()
	end

	local serverId = table.remove(ServerList, 1)

	if serverId then
		TriedServers[serverId] = true
		SaveServerCache()
	end

	return serverId
end

--================================================--
-- SERVER HOP (IMPROVED WITH ATTEMPT LIMIT)
--================================================--

local function ServerHop()
	if not Config.Server.AutoHop then
		return
	end

	State.HopAttempts += 1

	if State.HopAttempts > MAX_HOP_ATTEMPTS then
		Warn("[HOP] Max hop attempts reached, stopping")
		State.HopAttempts = 0
		return
	end

	Log("=================")
	Log("START SERVER HOP")
	Log("Attempt:", State.HopAttempts, "/", MAX_HOP_ATTEMPTS)

	local target = GetNextServer()

	if not target then
		Warn("NO SERVER TARGET")
		task.wait(Config.Server.HopDelay)
		ServerList = GetAllServers()
		target = GetNextServer()

		if not target then
			Warn("[HOP] Still no target after refresh")
			return
		end
	end

	Log("[TELEPORT]", target)

	local ok, err = pcall(function()
		TeleportService:TeleportToPlaceInstance(PlaceId, target, LocalPlayer)
	end)

	if not ok then
		Warn("[TELEPORT ERROR]", err)
		-- Don't recurse, let main loop handle retries
	end
end

--================================================--
-- TELEPORT FAILED
--================================================--

TeleportService.TeleportInitFailed:Connect(
	function(player, result, message)
		Warn("[TELEPORT FAILED]", result, message)
		task.wait(Config.Server.HopDelay)
		ServerHop()
	end
)

--================================================--
-- RESET SCAN STATE
--================================================--

local function ResetScan()
	table.clear(State.FoundItems)
	table.clear(State.UsedUUID)
	State.FoundCount = 0
end

--================================================--
-- WAIT FOR SCANNABLE BOOTH
--================================================--

local function WaitForScannableBooth(timeout)
	timeout = timeout or 60

	local startTime = os.clock()

	Log("========================================")
	Log("[BOOTH READY CHECK] START")
	Log("[BOOTH READY CHECK] Timeout:", timeout, "seconds")
	Log("========================================")

	while os.clock() - startTime < timeout do
		local islands = workspace:FindFirstChild("Islands")
		local tradePlaza = islands and islands:FindFirstChild("TradePlaza", true)
		local booths = tradePlaza and tradePlaza:FindFirstChild("Booths")

		local foundItem = false
		local boothCount = 0
		local itemCount = 0

		if booths then
			for _, booth in ipairs(booths:GetChildren()) do
				boothCount += 1

				local plane = booth:FindFirstChild("Plane")
				if plane then
					local surfaceGui = plane:FindFirstChild("SurfaceGui")
					if surfaceGui then
						local items = surfaceGui:FindFirstChild("Items")
						if items then
							for _, item in ipairs(items:GetChildren()) do
								if item:IsA("Frame") then
									itemCount += 1
									foundItem = true
									Log("----------------------------------------")
									Log("[BOOTH WITH ITEM FOUND]")
									Log("Booth:", booth.Name)
									Log("Item:", item.Name)
									Log("Path:", item:GetFullName())
									Log("----------------------------------------")
									break
								end
							end

							if foundItem then
								break
							end
						end
					end
				end
			end
		end

		Log(
			"[BOOTH CHECK]",
			"Booths:", boothCount,
			"| Items:", itemCount,
			"| Time:", string.format("%.1f", os.clock() - startTime) .. "s"
		)

		if foundItem then
			Log("========================================")
			Log("[BOOTH READY] Minimal 1 item ditemukan")
			Log("[BOOTH READY] Scan can start")
			Log("========================================")
			return true
		end

		task.wait(0.5)
	end

	Log("========================================")
	Warn("[BOOTH READY TIMEOUT]")
	Warn("[BOOTH READY TIMEOUT] No scannable item for", timeout, "seconds")
	Log("========================================")

	return false
end

--================================================--
-- RUN SCAN
--================================================--

local function RunScan()
	Log("======================")
	Log("🎣 START SCAN")
	Log("JOB:", game.JobId)

	ResetScan()

	task.wait(Config.LoadDelay)

	if not WaitForScannableBooth(60) then
		Warn("[SCAN ABORTED] No booth with item within 60 seconds")
		return false
	end

	Log("[SCAN BOOTH]")

	local ok, err = pcall(ScanBooths)

	if not ok then
		Warn("[SCAN ERROR]", err)
		return false
	end

	Log("[FOUND]", State.FoundCount)

	if State.FoundCount > 0 then
		SendWebhook(State.FoundItems)
	end

	State.HopAttempts = 0 -- Reset on successful scan
	return true
end

--================================================--
-- MAIN LOOP (IMPROVED)
--================================================--

local function StartFinder()
	if State.IsRunning then
		Warn("[FINDER] Already running")
		return
	end

	State.IsRunning = true

	Log("🎣 PLAZA SCANNER START")

	while State.IsRunning do
		local ok, scanCompleted = pcall(RunScan)

		if not ok then
			Warn("[MAIN ERROR]", scanCompleted)
			scanCompleted = false
		end

		if not scanCompleted then
			if Config.Server.AutoHop then
				Log("[HOP] Scan tidak selesai, server dianggap stuck")
				task.wait(Config.Server.HopDelay)
				ServerHop()
				break
			end
		else
			if Config.Server.AutoHop then
				Log("[HOP AFTER]", Config.Server.HopDelay)
				task.wait(Config.Server.HopDelay)
				ServerHop()
				break
			end
		end

		task.wait(10)
	end
end

--================================================--
-- INIT
--================================================--

if not _G.PLAZA_SCANNER_RUNNING then
	_G.PLAZA_SCANNER_RUNNING = true
	LoadServerCache()
	task.spawn(StartFinder)
	Log("🎣 PLAZA SCANNER FISHIT READY")
else
	Warn("[FINDER] Scanner already initialized")
end
