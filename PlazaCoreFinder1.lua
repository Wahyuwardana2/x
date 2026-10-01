--================================================--
-- PLAZA SCANNER
--================================================--

local Players = game("Players")
local HttpService = game("HttpService")
local TeleportService = game("TeleportService")
local ReplicatedStorage = game("ReplicatedStorage")

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
("Controllers")
("Trading")
("RAPController")
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

    ------------------------------------------------
    -- FISH
    ------------------------------------------------

    Fish = {

        Enabled = true,

        Name = {

            Enabled = true,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

            List = {
                "megalodon",
                -- "stormshell brute",
                -- "wintertusk mammofin"
                -- "overlord hydra",
                -- "elemental hydra"
            }

        },

        Mutation = {

            Enabled = true,
            Require = true, -- true = wajib ada mutation, false = normal boleh

            Mode = "Blacklist",
            Match = "Exact",

            List = {
                "Shiny"
            }

        },

        Price = {
            Enabled = true,
            Min = 1,
            Max = 200
        },

        RAP = {
            Enabled = false,
            Percent = 1
        }

    },


    ------------------------------------------------
    -- GEARS
    ------------------------------------------------

    Gears = {

        Enabled = true,

        Name = {

            Enabled = true,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Contains", -- Exact / Contains / StartsWith / EndsWith

            List = {
                "Withering Core",
                -- "Tribunal Withering Core"
            }

        },

        Mutation = {

            Enabled = true,
            Require = true, -- true = wajib ada mutation, false = normal boleh

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
            Max = 30
        },

        RAP = {
            Enabled = false,
            Percent = 1
        }

    },


    ------------------------------------------------
    -- FISHING RODS
    ------------------------------------------------

    ["Fishing Rods"] = {

        Enabled = true,

        Name = {

            Enabled = true,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

            List = {
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
                -- "empyrean staff",
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
				"devourer",
				"prize fighter",
                "blossom kunai",
                "shiro kunai",
                -- "frosted guitar",
                -- "oceanic trident",
                "wings of everlove"
                -- "spirit staff",
                -- "pirate banjo",
                -- "reaver scyte",
                -- "void kraken",
                -- "voidpunk axe"

                -- "Spirit Staff"
                -- "cinderflare",
                -- "ducky paradise",
                -- "eerie stormwake",
                -- "featerfall",
                -- "forsaken",
                -- "lantern",
                -- "pinata",
                -- "candy cane rod",
                -- "constellatio",
                -- "blossom conqueror",
                -- "galaxy conqueror",
                -- "queen kraken",
                -- "abyssfire",
                -- "soulreaver",
                -- "pirate octopus",
                -- "crowned Hacker",
                -- "blazing fire",
                -- "dark seahorse"
            }

        },

        Price = {
            Enabled = false,
            Min = 1,
            Max = 100
        },

        RAP = {

            Enabled = false,
            Percent = 1

        }

    },


    ------------------------------------------------
    -- PETS
    ------------------------------------------------

    ["Pets"] = {

        Enabled = true,

        Name = {

            Enabled = false,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Contains", -- Exact / Contains / StartsWith / EndsWith

            List = {
                "Stellar Hedgehog"
            }

        },

        Price = {
            Enabled = false,
            Min = 4500,
            Max = 8000
        },

        RAP = {
            Enabled = true,
            Min = 1000,
            Max = 100000,
            Percent = nil
        }

    },


    ------------------------------------------------
    -- BOATS
    ------------------------------------------------

    Boats = {

        Enabled = true,

        Name = {

            Enabled = false,

            Mode = "Blacklist", -- Whitelist / Blacklist

            Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

            List = {
                "dinky fishing boat",
                "raft",
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
            Min = 1000,
            Max = 100000,
            Percent = nil

        }

    },


    ------------------------------------------------
    -- EQUIPMENT
    ------------------------------------------------

    Equipment = {

        Enabled = false,

        Name = {

            Enabled = true,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

            List = {

            }

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


    ------------------------------------------------
    -- TROPHIES
    ------------------------------------------------

    Trophies = {

        Enabled = false,

        Name = {

            Enabled = true,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

            List = {

            }

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


    ------------------------------------------------
    -- ENCHANT
    ------------------------------------------------

    ["Enchant Stones"] = {

        Enabled = true,

        Name = {

            Enabled = true,

            Mode = "Whitelist", -- Whitelist / Blacklist

            Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

            List = {
                "Runic Enchant Stone",
                "Eggy Enchant Stone"
            }

        },

        Price = {
            Enabled = false,
            Min = 1,
            Max = 100
        },

        RAP = {

            Enabled = true,
            Percent = 2

        }

    }

},
	--================================================--
	-- SERVER
	--================================================--

	Server = {
		AutoHop = true,
		MinPlayer = 1,
		MaxPlayer = 20,
		HopDelay = 3
	}
}

--================================================--
-- APPLY EXTERNAL CONFIG
--================================================--

if type(ExternalConfig.Webhook) == "table" then
Config.Webhook = ExternalConfig.Webhook
end

--================================================--
-- OPTIONAL OVERRIDE
--================================================--

-- Kalau nanti mau seluruh config bisa dikirim
-- dari executor, bagian ini bisa digunakan.

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
Config.Items = ExternalConfig.Items
end

if type(ExternalConfig.Server) == "table" then
for key, value in pairs(ExternalConfig.Server) do
Config.Server[key] = value
end
end

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

text = text:lower()

text = text:gsub("%s+", " ")

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

local webhook =
	Config.Webhook[itemType]

if type(webhook) ~= "string" then
	return nil
end

if webhook == "" then
	return nil
end

return webhook

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

local result =
	tostring(name or "")

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

local function GetRAP(
itemType,
itemName,
item
)

if not RAPController then

	print(
		"[RAP] CONTROLLER NIL"
	)

	return nil
end

local ok, rap =
	pcall(function()

		if itemType == "Pets"
			and item.ItemId
		then

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

local function CheckFilter(
value,
cfg
)

if not cfg
	or not cfg.Enabled
then
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

			found =
				value == text

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

local function CheckMutation(
mutation,
cfg
)

if not cfg
	or not cfg.Enabled
then
	return true
end

mutation = Clean(mutation)

if cfg.Require
	and (
		mutation == ""
		or mutation == "normal"
		or mutation == "nill"
	)
then

	return false
end

for _, bad in ipairs(
	cfg.List or {}
) do

	local target =
		Clean(bad)

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
	category
	and category.Price

if not cfg
	or not cfg.Enabled
then
	return true
end

local price =
	tonumber(item.Price) or 0

if cfg.Min
	and price < cfg.Min
then

	DebugPrint(
		"[PRICE TOO LOW]",
		item.Name,
		price
	)

	return false
end

if cfg.Max
	and price > cfg.Max
then

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
	category
	and category.RAP

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

-- RAP OFF = tidak memfilter
if not cfg
	or not cfg.Enabled
then
	return true
end

