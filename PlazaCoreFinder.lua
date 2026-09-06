--================================================--
-- PLAZA SCANNER
-- CORE + CONFIG + RAP + FILTER + SCANNER + HOP
--================================================--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId

--================================================--
-- RAP CONTROLLER
--================================================--

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

	Webhook = {
		-- Fish = "https://discordapp.com/api/webhooks/1545775285440352358/s6SeBi5VGOPZoB17ROgTJkjPNIFzrR3a_8JrvXWG90BjKm7VKz8n_emzeGlAO2P0ncoQ",
		-- Gears = "https://discordapp.com/api/webhooks/1545775589120811028/6_5HCrn52hyNW8ENqxJC5JQ8zGzWmRDaS8_l-K6BtTDvblkLGqcvN9ic_FZ0T8egHfGc",
		-- ["Fishing Rods"] = "https://discordapp.com/api/webhooks/1545775680032084009/9Mn30_SDOcLLt3boKd15ufSPUCKum2nuMMDJH9D_ZGTpmhWmwnGNsnXd504mXETzHqDS",
		-- Boats = "https://discordapp.com/api/webhooks/1545775796814086237/UYgAEeiAcCXiuYQeaoJXBrT7l_GB-sjogmxgORcBQ-sf25cG7kpCJ132XCZZSmBh791b",
		-- Pets = "https://discordapp.com/api/webhooks/1545775864476868640/UKY5zc8FNK8qcHC6wmM_7xBlgRR0sCHMoYrPPqKh-CrYTjgSaCvy63mt2cAOaWqEbEBZ"

		
		Fish = "https://discordapp.com/api/webhooks/1530612875272654961/u2FmJrJssywDYVh-5dWguka_5fpZkyzoCbioZhS-ctNIjYTTJ-1rIppT2hDXXmdbwsnn",
		Gears = "https://discordapp.com/api/webhooks/1545702465297449053/Chshx2Ate62mesZfZKsZ6ldGp8XcbWekE4yj1ZzkCSmAIEdCH8XRsOgeT7OoHigaxRYN",
		["Fishing Rods"] = "https://discordapp.com/api/webhooks/1530613393306685612/1hBlQwnCzjbVdfQYR1RzfB07e64wDxBPcMCPRM1hFprZQDdHYqYZFHO82L5ZFQDi3aoq",
		Boats = "https://discordapp.com/api/webhooks/1530613586525815027/osI8YKDYkl_bwCCVT4S6-W-bblZMZ9gTRLhVfLseGuxWIAwz2EN1vpNz1Jl1IisVlPDX",
		Pets = "https://discordapp.com/api/webhooks/1531668953816891493/myibJmPBQBA_0W3dICiFklJxX_h8ZUyawZVge1cZR9T2UlvLqgU1Mj7mK7e3VkZBL8Lx"
	},

	Debug = true,
	LoadDelay = 2,
	StayTime = 20,

	Items = {

		Fish = {
			Enabled = true,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Exact",

				List = {
					"pyrocoil",
					-- "megalodon",
					"stormshell brute",
					"wintertusk mammofin",
					-- "overlord hydra",
					-- "elemental hydra"
				}
			},

			Mutation = {
				Enabled = false,
				Require = false,
				Mode = "Blacklist",
				Match = "Exact",
				List = {"Shiny"}
			},

			Price = {
				Enabled = false,
				Min = 1,
				Max = 196
			},

			RAP = {
				Enabled = true,
				Percent = 30
			}
		},

		Gears = {
			Enabled = true,

			Name = {
				Enabled = true,
				Mode = "Whitelist",
				Match = "Exact",
				List = {
					"Withering Core",
					"Tribunal Withering Core"
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

		["Fishing Rods"] = {
			Enabled = true,

			Name = {
				Enabled = true,
				Mode = "Blacklist",
				Match = "Exact",

				List = {
					-- "frozen rod",
					-- "verdis blade",
					-- "gold rod",
					-- "hyper rod",
					-- "ghoul rod",
					-- "crystalized",
					-- "abyssal chroma",
					-- "jelly",
					-- "galactic",
					-- "enlightened",
					-- "cursed soul",
					-- "continuum",
					-- "holy trident",
					-- "electric guitar",
					-- "element rod",
					-- "oceanic harpoon",
					-- "soul scythe",
					-- "undead guitar",
					-- "divine blade",
					-- "heartfelt blade",
					-- "eclipse katana",
					-- "princess parasol",
					-- "corruption edge",
					-- "1x1x1x1 ban hammer",
					-- "binary edge",
					-- "the vanquisher",
					-- "dragon spirit",
					-- "frozen krampus scythe",
					-- "candy cane trident",
					-- "gingerbread katana",
					-- "christmas parasol",
					-- "diamond rod",
					-- "eternal flower",
					-- "blackhole sword",
					-- "kraken anchor",
					-- "ethereal sword",
					-- "chromatic katana",
					-- "crescendo scythe",
					-- "aether monarch",
					-- "cupid's harp",
					-- "aurelian bow",
					-- "kitty guitar",
					-- "dark matter scythe",
					-- "crimson retribution",
					-- "kitsune greatsword",
					-- "celestial scythe",
					-- "serpent's trident",
					-- "absolute divinity",
					-- "draconic soul",
					-- "divine staff",
					-- "easter parasol",
					-- "bunny summoner",
					-- "fallen staff",
					-- "golden clockwork",

					"empyrean staff"

					-- "void guitar",
					-- "cloud weaver",
					-- "overdrive",
					-- "blossom guitar",
					-- "butterfly sword",
					-- "galaxy conqueror",
					-- "blossom conqueror",
					-- "world tour football",
					-- "dragonmaster scythe",
					-- "sunshine cello",
					-- "intergalactic sniper",
					-- "starweaver's globe",
					-- "silverweaver's globe",
					-- "blossom kunai",
					-- "shiro kunai",
					-- "frosted guitar",
					-- "oceanic trident",
					-- "wings of everlove",
					-- "spirit staff",
					-- "pirate banjo",
					-- "reaver scyte",
					-- "void kraken",
					-- "voidpunk axe",
					-- "gingerbread sword"
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

		Pets = {
			Enabled = true,

			Name = {
				Enabled = false,
				Mode = "Whitelist",
				Match = "Contains",
				List = {"Stellar Hedgehog"}
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
					"santa sled",
					"swan boat",
					"pumpkin boat",
					"christmas car",
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

	Server = {
		AutoHop = false,
		MinPlayer = 1,
		MaxPlayer = 20,
		HopDelay = 1
	}
}

--================================================--
-- STATE
--================================================--

local FoundItems = {}
local UsedUUID = {}
local FoundCount = 0

--================================================--
-- HELPERS
--================================================--

local function DebugPrint(...)
	if Config.Debug then
		print(...)
	end
end

--================================================--
-- CLEAN / NORMALIZE
--================================================--

local function Clean(value)

	if value == nil then
		return ""
	end

	local text = tostring(value)

	-- lowercase
	text = text:lower()

	-- ubah whitespace berulang menjadi satu spasi
	text = text:gsub("%s+", " ")

	-- hapus spasi awal
	text = text:match("^%s*(.-)%s*$")

	return text
end

--================================================--
-- CATEGORY
--================================================--

local function GetCategory(itemType)
	return Config.Items[itemType]
end

local function GetWebhook(itemType)
	return Config.Webhook[itemType]
end

--================================================--
-- WIB TIME
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

		result = result:gsub(
			"^" .. prefix,
			""
		)

	end

	return result
end

--================================================--
-- RAP
--================================================--

local function GetRAP(itemType, itemName, item)

	if not RAPController then
		print("[RAP] CONTROLLER NIL")
		return nil
	end

	local ok, rap = pcall(function()

		if itemType == "Pets" and item.ItemId then

			return RAPController:GetRAP(
				"Pets",
				item.ItemId
			)

		end

		if item.ItemId then

			local result =
				RAPController:GetRAP(
					itemType,
					item.ItemId
				)

			if result then
				return result
			end

		end

		return RAPController:GetRAP(
			itemType,
			CleanRAPName(
				item.BaseName or itemName
			)
		)

	end)

	print(
		"[RAP FINAL]",
		itemType,
		itemName,
		item.ItemId,
		ok,
		rap
	)

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

		-- Whitelist kosong = tidak ada yang lolos
		-- Blacklist kosong = semua lolos
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

				found =
					value:find(
						text,
						1,
						true
					) ~= nil

			elseif cfg.Match == "StartsWith" then

				found =
					value:sub(
						1,
						#text
					) == text

			elseif cfg.Match == "EndsWith" then

				found =
					value:sub(
						-#text
					) == text
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

	if cfg.Require and (
		mutation == ""
		or mutation == "normal"
		or mutation == "nill"
	) then

		return false
	end

	for _, bad in ipairs(cfg.List or {}) do

		local target = Clean(bad)
		local matched = false

		if cfg.Match == "Exact" then

			matched =
				mutation == target

		elseif cfg.Match == "Contains" then

			matched =
				mutation:find(
					target,
					1,
					true
				) ~= nil

		elseif cfg.Match == "StartsWith" then

			matched =
				mutation:sub(
					1,
					#target
				) == target

		elseif cfg.Match == "EndsWith" then

			matched =
				mutation:sub(
					-#target
				) == target
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

	local category =
		GetCategory(item.ItemType)

	local cfg =
		category and category.Price

	if not cfg or not cfg.Enabled then
		return true
	end

	local price =
		tonumber(item.Price) or 0

	if cfg.Min and price < cfg.Min then

		DebugPrint(
			"[PRICE TOO LOW]",
			item.Name,
			price
		)

		return false
	end

	if cfg.Max and price > cfg.Max then

		DebugPrint(
			"[PRICE TOO HIGH]",
			item.Name,
			price
		)

		return false
	end

	return true
end

--================================================--
-- RAP FILTER + DISPLAY
--================================================--

local function CheckRAP(item)

	local category =
		GetCategory(item.ItemType)

	local cfg =
		category and category.RAP

	-- Tetap ambil RAP walaupun filter OFF
	local rap =
		GetRAP(
			item.ItemType,
			item.Name,
			item
		)

	if rap then
		item.RAP = rap
	end

	-- RAP OFF = hanya tidak memfilter
	if not cfg or not cfg.Enabled then
		return true
	end

	-- RAP tidak ditemukan = tetap lolos
	if not rap then
		return true
	end

	--================================================--
	-- RAP MIN
	--================================================--

	if cfg.Min and rap < cfg.Min then

		DebugPrint(
			"[RAP TOO LOW]",
			item.Name,
			"RAP:",
			rap,
			"MIN:",
			cfg.Min
		)

		return false
	end

	--================================================--
	-- RAP MAX
	--================================================--

	if cfg.Max and rap > cfg.Max then

		DebugPrint(
			"[RAP TOO HIGH]",
			item.Name,
			"RAP:",
			rap,
			"MAX:",
			cfg.Max
		)

		return false
	end

	--================================================--
	-- UNDER RAP PERCENT
	--================================================--

	if cfg.Percent ~= nil then

		local percent =
			tonumber(cfg.Percent) or 0

		local limit =
			rap * (100 - percent) / 100

		if item.Price > limit then

			DebugPrint(
				"[OVER RAP LIMIT]",
				item.Name,
				"PRICE:",
				item.Price,
				"RAP:",
				rap,
				"REQUIRED:",
				percent .. "%",
				"MAX PRICE:",
				limit
			)

			return false
		end

		if rap > 0 then

			item.UnderRap =
				math.floor(
					(1 - item.Price / rap) * 100
				)

		end
	end

	return true
end

--================================================--
-- CATEGORY FILTER
--================================================--

local function CheckCategory(item)

	local category =
		GetCategory(item.ItemType)

	if not category then

		DebugPrint(
			"[UNKNOWN TYPE]",
			item.ItemType
		)

		return false
	end

	if not category.Enabled then
		return false
	end

	--================================================--
	-- NAME
	--================================================--

	if category.Name then

		local name

		if item.BaseName
			and item.BaseName ~= ""
		then
			name = item.BaseName
		else
			name = item.Name
		end

		local result =
			CheckFilter(
				name,
				category.Name
			)

		DebugPrint(
			"[NAME CHECK]",
			"Type:",
			item.ItemType,
			"Display:",
			item.Name,
			"Base:",
			item.BaseName,
			"Clean:",
			Clean(name),
			"Mode:",
			category.Name.Mode,
			"Match:",
			category.Name.Match,
			"Result:",
			result
		)

		if not result then

			DebugPrint(
				"[NAME FAIL]",
				item.Name,
				"BASE:",
				item.BaseName
			)

			return false
		end

	elseif category.FilterName then

		if not CheckNameFilter(
			item,
			category.Names
		) then

			DebugPrint(
				"[NAME FAIL]",
				item.Name
			)

			return false
		end
	end

	--================================================--
	-- VARIANT
	--================================================--

	if category.Variant
		and not CheckFilter(
			item.Variant,
			category.Variant
		)
	then

		DebugPrint(
			"[VARIANT FAIL]",
			item.Name,
			item.Variant
		)

		return false
	end

	--================================================--
	-- SIZE
	--================================================--

	if category.Size
		and not CheckFilter(
			item.Size,
			category.Size
		)
	then

		DebugPrint(
			"[SIZE FAIL]",
			item.Name,
			item.Size
		)

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

	if obj:IsA("TextLabel")
		or obj:IsA("TextButton")
	then

		return obj.Text or ""

	end

	return ""
end

local function GetImage(frame)

	local image

	pcall(function()

		image =
			frame:FindFirstChildWhichIsA(
				"ImageLabel",
				true
			)

	end)

	if image and image.Image then

		return image.Image:gsub(
			"rbxassetid://",
			""
		)

	end

	return nil
end

--================================================--
-- ITEM PARSER
--================================================--

local function ParseItemDetail(item, inside)

	item.BaseName = item.Name
	item.Size = ""

	--================================================--
	-- SIZE
	--================================================--

	local bigFrame =
		inside:FindFirstChild(
			"BigFrame",
			true
		)

	if bigFrame and bigFrame.Visible then

		local label =
			bigFrame:FindFirstChild(
				"Label",
				true
			)

		item.Size =
			label and label.Text or "Big"
	end

	--================================================--
	-- MUTATION
	--================================================--

	local mutation =
		inside:FindFirstChild(
			"VariantLabel",
			true
		)

	if mutation and mutation.Visible then

		local text =
			GetText(mutation)

		if text ~= "" then
			item.Mutation = text
		end
	end

	--================================================--
	-- VARIANT
	--================================================--

	local shiny =
		inside:FindFirstChild(
			"ShinyFrame",
			true
		)

	if shiny and shiny.Visible then

		local label =
			shiny:FindFirstChild(
				"Label",
				true
			)

		if label then
			item.Variant = label.Text
		end
	end

	--================================================--
	-- PREFIX
	--================================================--

	local name =
		item.Name

	local lower =
		name:lower()

	if lower:find("^big shiny ") then

		if item.Size == "" then
			item.Size = "Big"
		end

		if item.Mutation == "" then
			item.Mutation = "Shiny"
		end

		item.BaseName =
			name:gsub(
				"^[Bb][Ii][Gg]%s+[Ss][Hh][Ii][Nn][Yy]%s+",
				""
			)

	elseif lower:find("^big ") then

		if item.Size == "" then
			item.Size = "Big"
		end

		item.BaseName =
			name:gsub(
				"^[Bb][Ii][Gg]%s+",
				""
			)

	elseif lower:find("^shiny ") then

		if item.Mutation == "" then
			item.Mutation = "Shiny"
		end

		item.BaseName =
			name:gsub(
				"^[Ss][Hh][Ii][Nn][Yy]%s+",
				""
			)
	end
end

--================================================--
-- WEIGHT
--================================================--

local function GetWeight(item, inside)

	if item.ItemType ~= "Fish" then
		return ""
	end

	local frame =
		inside:FindFirstChild(
			"WeightFrame",
			true
		)

	if not frame or not frame.Visible then
		return "-"
	end

	local label =
		frame:FindFirstChild(
			"Label",
			true
		)

	if label then
		return label.Text
	end

	local text =
		frame:FindFirstChildWhichIsA(
			"TextLabel",
			true
		)

	return text and text.Text or "-"
end

--================================================--
-- ORIGINAL NAME
--================================================--

local function GetOriginalName(
	itemType,
	itemId
)

	if not itemId
		or not RAPController
	then
		return nil
	end

	local ok, result =
		pcall(function()

			return RAPController:GetItemName(
				itemType,
				itemId
			)

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

	local ok, name =
		pcall(function()

			return Players:GetNameFromUserIdAsync(
				userId
			)

		end)

	return ok and name or tostring(userId)
end

--================================================--
-- CHECK ITEM
--================================================--

local function CheckItem(
	frame,
	booth
)

	local uuid =
		frame:GetAttribute(
			"ItemUUID"
		)

	if uuid
		and UsedUUID[uuid]
	then
		return
	end

	local inside =
		frame:FindFirstChild(
			"Inside"
		)

	if not inside then
		return
	end

	local buy =
		frame:FindFirstChild(
			"Buy"
		)

	local item = {

		ItemUUID = uuid,

		ItemType =
			frame:GetAttribute(
				"ItemType"
			),

		ItemId =
			frame:GetAttribute(
				"ItemId"
			),

		RawName = "",

		Image =
			GetImage(frame),

		Name = "",
		BaseName = "",
		Variant = "",
		Mutation = "",
		Size = "",
		Weight = "",

		Price =
			buy
			and buy:GetAttribute(
				"LastKnownPrice"
			)
			or 0,

		RAP = nil,
		UnderRap = nil
	}

	--================================================--
	-- NAME
	--================================================--

	local label =
		inside:FindFirstChild(
			"Label",
			true
		)

	if label then
		item.Name =
			GetText(label)
	end

	if item.Name == "" then
		return
	end

	--================================================--
	-- PARSE
	--================================================--

	ParseItemDetail(
		item,
		inside
	)

	--================================================--
	-- PET ORIGINAL NAME
	--================================================--

	if item.ItemType == "Pets" then

		local original =
			GetOriginalName(
				item.ItemType,
				item.ItemId
			)

		if original then

			item.RawName =
				original

			print(
				"[PET NAME DEBUG]",
				item.Name,
				item.ItemId,
				item.RawName
			)

		else

			item.RawName =
				item.BaseName

		end
	end

	item.Weight =
		GetWeight(
			item,
			inside
		)

	--================================================--
	-- CATEGORY FILTER
	--================================================--

	if not CheckCategory(item) then
		return
	end

	local category =
		GetCategory(
			item.ItemType
		)

	--================================================--
	-- MUTATION
	--================================================--

	if category.Mutation
		and not CheckMutation(
			item.Mutation,
			category.Mutation
		)
	then

		DebugPrint(
			"[MUTATION FAIL]",
			item.Name,
			item.Mutation
		)

		return
	end

	--================================================--
	-- PRICE
	--================================================--

	if not CheckPrice(item) then
		return
	end

	--================================================--
	-- RAP
	--================================================--

	if not CheckRAP(item) then
		return
	end

	--================================================--
	-- SELLER
	--================================================--

	item.Seller =
		GetSeller(
			booth:GetAttribute(
				"Owner"
			)
		)

	--================================================--
	-- UUID
	--================================================--

	if uuid then
		UsedUUID[uuid] = true
	end

	table.insert(
		FoundItems,
		item
	)

	FoundCount += 1

	--================================================--
	-- DEBUG
	--================================================--

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

--================================================--
-- SCAN BOOTHS
--================================================--

local function ScanBooths()

	local islands =
		workspace:FindFirstChild(
			"Islands"
		)

	if not islands then
		return
	end

	local trade =
		islands:FindFirstChild(
			"TradePlaza",
			true
		)

	if not trade then
		return
	end

	local booths =
		trade:FindFirstChild(
			"Booths"
		)

	if not booths then
		return
	end

	for _, booth in ipairs(
		booths:GetChildren()
	) do

		local plane =
			booth:FindFirstChild(
				"Plane"
			)

		if plane then

			local gui =
				plane:FindFirstChild(
					"SurfaceGui"
				)

			if gui then

				local items =
					gui:FindFirstChild(
						"Items"
					)

				if items then

					for _, frame in ipairs(
						items:GetChildren()
					) do

						if frame:IsA("Frame") then

							CheckItem(
								frame,
								booth
							)

						end
					end
				end
			end
		end
	end
end

--================================================--
-- ITEM TEXT
--================================================--

local function BuildItemText(item)

	local text =
		"━━━━━━━━━━━━━━\n\n" ..
		"🎣 ***`" ..
		tostring(
			item.Name or "-"
		) ..
		"`***\n\n" ..

		"**Seller**\n" ..
		tostring(
			item.Seller or "-"
		) ..

		"\n\n" ..

		"Type : " ..
		tostring(
			item.ItemType or "-"
		) ..

		"\n\n"

	if item.Variant
		and item.Variant ~= ""
	then

		text ..=
			"Variant : " ..
			item.Variant ..
			"\n"

	end

	if item.Mutation
		and item.Mutation ~= ""
	then

		text ..=
			"Mutation : ***`" ..
			item.Mutation ..
			"`***\n"

	end

	if item.Size
		and item.Size ~= ""
	then

		text ..=
			"Size : " ..
			item.Size ..
			"\n"

	end

	if item.Weight
		and item.Weight ~= ""
		and item.Weight ~= "-"
	then

		text ..=
			"Weight : " ..
			item.Weight ..
			"\n"

	end

	text ..=
		"\nPrice : ***`" ..
		tostring(
			item.Price or 0
		) ..
		"`***" ..

		"\nRAP : " ..
		tostring(
			item.RAP or "-"
		) ..
		"\n"

	if item.UnderRap then

		text ..=
			"Under RAP : ***`" ..
			tostring(
				item.UnderRap
			) ..
			"%`***\n"

	end

	return text .. "\n"
end

--================================================--
-- WEBHOOK
--================================================--

local function SendWebhook(items)

	local grouped = {}

	-- GROUP BY WEBHOOK
	for _, item in ipairs(items) do

		local webhook =
			GetWebhook(
				item.ItemType
			)

		if webhook
			and webhook ~= ""
		then

			grouped[webhook] =
				grouped[webhook] or {}

			table.insert(
				grouped[webhook],
				item
			)

		end
	end

	local req =
		request
		or http_request
		or syn.request

	if not req then

		warn(
			"[WEBHOOK] REQUEST FUNCTION NOT FOUND"
		)

		return
	end

	for webhook, list in pairs(
		grouped
	) do

		local itemText = ""

		for _, item in ipairs(list) do

			local add =
				BuildItemText(item)

			if #itemText + #add > 900 then
				break
			end

			itemText ..= add
		end

		local jobId =
			game.JobId

		local joinLink =
			"https://www.roblox.com/games/start?placeId=" ..
			game.PlaceId ..
			"&gameInstanceId=" ..
			jobId

		local payload = {

			username =
				"PLAZA SCANNER BOT",

			avatar_url =
				"https://raw.githubusercontent.com/Wahyuwardana2/x/refs/heads/main/FindMe.png",

			embeds = {{

				title =
					"🎣 PLAZA SCANNER FOUND (" ..
					#list ..
					" ITEMS)",

				color = 65280,

				fields = {

					{
						name = "Server",

						value =
							#Players:GetPlayers() ..
							"/" ..
							Players.MaxPlayers,

						inline = false
					},

					{
						name = "JobId",

						value =
							"📋 Copy mobile:\n`" ..
							jobId ..
							"`\n\n" ..

							"📋 Copy desktop:\n```" ..
							jobId ..
							"```",

						inline = false
					},

					{
						name = "Join Server",

						value =
							"🔗 " ..
							joinLink,

						inline = false
					},

					{
						name = "Items",

						value =
							itemText,

						inline = false
					}
				},

				footer = {

					text =
						"PLAZA SCANNER | " ..
						game.JobId ..
						" | " ..
						GetWIBTime()
				}
			}}
		}

		local ok, err =
			pcall(function()

				req({

					Url = webhook,

					Method = "POST",

					Headers = {
						["Content-Type"] =
							"application/json"
					},

					Body =
						HttpService:JSONEncode(
							payload
						)
				})

			end)

		if ok then

			print(
				"[WEBHOOK SENT]",
				#list,
				webhook
			)

		else

			warn(
				"[WEBHOOK ERROR]",
				err
			)

		end
	end
end

--================================================--
-- SERVER CACHE
--================================================--

local ServerCacheFile =
	"JP_FINDER_V7_2_SERVERS.json"

local ServerList = {}
local TriedServers = {}

local function SaveServerCache()

	if not writefile then
		return
	end

	pcall(function()

		writefile(
			ServerCacheFile,

			HttpService:JSONEncode({

				Servers =
					ServerList,

				Tried =
					TriedServers

			})
		)

	end)
end

local function LoadServerCache()

	if not readfile
		or not isfile
	then
		return
	end

	if not isfile(
		ServerCacheFile
	) then
		return
	end

	local ok, data =
		pcall(function()

			return HttpService:JSONDecode(
				readfile(
					ServerCacheFile
				)
			)

		end)

	if ok and data then

		ServerList =
			data.Servers or {}

		TriedServers =
			data.Tried or {}

		print(
			"[CACHE LOADED]",
			#ServerList
		)
	end
end

local function IsServerUsed(id)

	return TriedServers[id] == true
end

--================================================--
-- SCRAPE SERVERS
--================================================--

local function GetAllServers()

	print("=== SCRAPE SERVER ===")

	local servers = {}
	local cursor = ""

	for page = 1, 5 do

		local url =
			"https://games.roblox.com/v1/games/" ..
			tostring(PlaceId) ..
			"/servers/Public?sortOrder=Desc&limit=100"

		if cursor ~= "" then

			url ..=
				"&cursor=" ..
				cursor

		end

		local ok, response =
			pcall(function()

				return game:HttpGet(
					url
				)

			end)

		if not ok then

			warn(
				"[SCRAPE ERROR]"
			)

			break
		end

		local decode, data =
			pcall(function()

				return HttpService:JSONDecode(
					response
				)

			end)

		if not decode
			or not data
			or not data.data
		then
			break
		end

		for _, server in ipairs(
			data.data
		) do

			if
				server.id ~= game.JobId
				and server.playing >= Config.Server.MinPlayer
				and server.playing <= Config.Server.MaxPlayer
				-- and server.playing < server.maxPlayers
				and not IsServerUsed(
					server.id
				)
			then

				table.insert(
					servers,
					server.id
				)

			end
		end

		if not data.nextPageCursor then
			break
		end

		cursor =
			data.nextPageCursor

		task.wait(0.5)
	end

	print(
		"[SERVER FOUND]",
		#servers
	)

	return servers
end

--================================================--
-- NEXT SERVER
--================================================--

local function GetNextServer()

	if #ServerList == 0 then
		ServerList =
			GetAllServers()
	end

	if #ServerList == 0 then

		print(
			"[RESET SERVER CACHE]"
		)

		TriedServers = {}

		ServerList =
			GetAllServers()
	end

	local serverId =
		table.remove(
			ServerList,
			1
		)

	if serverId then

		TriedServers[serverId] =
			true

		SaveServerCache()
	end

	return serverId
end

--================================================--
-- SERVER HOP
--================================================--

local function ServerHop()

	if not Config.Server.AutoHop then
		return
	end

	print("=================")
	print("START SERVER HOP")

	local target =
		GetNextServer()

	if not target then

		warn(
			"NO SERVER TARGET"
		)

		task.wait(
			Config.Server.HopDelay
		)

		ServerList =
			GetAllServers()

		target =
			GetNextServer()

		if not target then
			return
		end
	end

	print(
		"[TELEPORT]",
		target
	)

	local ok, err =
		pcall(function()

			TeleportService:TeleportToPlaceInstance(
				PlaceId,
				target,
				LocalPlayer
			)

		end)

	if not ok then

		warn(
			"[TELEPORT ERROR]",
			err
		)

		task.wait(3)

		ServerHop()
	end
end

--================================================--
-- TELEPORT FAILED
--================================================--

TeleportService.TeleportInitFailed:Connect(
	function(
		player,
		result,
		message
	)

		warn(
			"[TELEPORT FAILED]",
			result,
			message
		)

		task.wait(
			Config.Server.HopDelay
		)

		ServerHop()
	end
)

--================================================--
-- RESET
--================================================--

local function ResetScan()

	table.clear(
		FoundItems
	)

	table.clear(
		UsedUUID
	)

	FoundCount = 0
end

--================================================--
-- RUN SCAN
--================================================--

local function RunScan()

	print("======================")
	print("🎣 START SCAN")
	print("JOB:", game.JobId)

	ResetScan()

	task.wait(
		Config.LoadDelay
	)

	print(
		"[SCAN BOOTH]"
	)

	local ok, err =
		pcall(
			ScanBooths
		)

	if not ok then

		warn(
			"[SCAN ERROR]",
			err
		)

	end

	print(
		"[FOUND]",
		FoundCount
	)

	if FoundCount > 0 then

		SendWebhook(
			FoundItems
		)

	end
end

--================================================--
-- MAIN LOOP
--================================================--

local function StartFinder()

	print(
		"🎣 PLAZA SCANNER START"
	)

	while true do

		local ok, err =
			pcall(
				RunScan
			)

		if not ok then

			warn(
				"[MAIN ERROR]",
				err
			)

		end

		if Config.Server.AutoHop then

			print(
				"[HOP AFTER]",
				Config.Server.HopDelay
			)

			task.wait(
				Config.Server.HopDelay
			)

			ServerHop()

			break
		end

		task.wait(10)
	end
end

--================================================--
-- INIT
--================================================--

LoadServerCache()

task.spawn(
	StartFinder
)

print(
	"🎣 PLAZA SCANNER FISHIT READY"
)
