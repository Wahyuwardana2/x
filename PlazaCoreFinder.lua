--================================================--
-- CORE + CONFIG + RAP + FILTER SYSTEM
--================================================--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local PlaceId = game.PlaceId



------------------------------------------------
-- RAP CONTROLLER
------------------------------------------------

local RAPController = nil


pcall(function()

    RAPController =
    require(
        ReplicatedStorage
        :WaitForChild("Controllers")
        :WaitForChild("Trading")
        :WaitForChild("RAPController")
    )

end)



------------------------------------------------
-- CONFIG 
------------------------------------------------

local Config = {


------------------------------------------------
-- DISCORD
------------------------------------------------

Webhook = {

    Fish =
    "https://discordapp.com/api/webhooks/1530612875272654961/u2FmJrJssywDYVh-5dWguka_5fpZkyzoCbioZhS-ctNIjYTTJ-1rIppT2hDXXmdbwsnn",


    Gears =
    "https://discordapp.com/api/webhooks/1530613045020069991/8gEwiqeGmaCus3ZzWYr14HVWOs5GdX0SC9Iyqevqj6fIDzOB37ozMEXUI1WxvjsbI46e",


    ["Fishing Rods"] =
    "https://discordapp.com/api/webhooks/1530613393306685612/1hBlQwnCzjbVdfQYR1RzfB07e64wDxBPcMCPRM1hFprZQDdHYqYZFHO82L5ZFQDi3aoq",


    Boats =
    "https://discordapp.com/api/webhooks/1530613586525815027/osI8YKDYkl_bwCCVT4S6-W-bblZMZ9gTRLhVfLseGuxWIAwz2EN1vpNz1Jl1IisVlPDX",
    Pets = "https://discordapp.com/api/webhooks/1531668953816891493/myibJmPBQBA_0W3dICiFklJxX_h8ZUyawZVge1cZR9T2UlvLqgU1Mj7mK7e3VkZBL8Lx" 

},
------------------------------------------------
-- DEBUG
------------------------------------------------

Debug = true,



------------------------------------------------
-- LOAD
------------------------------------------------
LoadDelay = 3,

StayTime = 7,



------------------------------------------------
-- ITEM SETTINGS
------------------------------------------------

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
    "pyrocoil",
    -- "stormshell brute",
    "wintertusk mammofin"
    }

},


Mutation = {

Enabled = false,
Require = false,  -- true = wajib ada mutation, false = normal boleh

Mode = "Blacklist",
Match = "Exact",
List = {

"Shiny"

}

},

Price = {
    Enabled = true,
    Min = 1,
    Max = 301
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

    Match = "Exact", -- Exact / Contains / StartsWith / EndsWith

    List = {
    "Withering Core"

    }

},

Mutation = {

Enabled = false,
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
    Enabled = true,
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
    "gold rod",
    "hyper rod",
    "ghoul rod",
    "crystalized",
    "abyssal chroma",
    "jelly",
    "galactic",
    "enlightened",
    "cursed soul",
    "continuum",
    "holy trident",
    "electric guitar",
    "element rod",
    "oceanic harpoon",
    "soul scythe",
    "undead guitar",
    "divine blade",
    "heartfelt blade",
    "eclipse katana",
    "princess parasol",
    "corruption edge",
    "1x1x1x1 ban hammer",
    "binary edge",
    "the vanquisher",
    "dragon spirit",
    "frozen krampus scythe",
    "candy cane trident",
    "gingerbread katana",
    "christmas parasol",
    "diamond rod",
    "eternal flower",
    "blackhole sword",
    "kraken anchor",
    "ethereal sword",
    "chromatic katana",
    "crescendo scythe",
    "aether monarch",
    "cupid's harp",
    "aurelian bow",
    "kitty guitar",
    "dark matter scythe",
    "crimson retribution",
    "kitsune greatsword",
    "celestial scythe",
    "serpent's trident",
    "absolute divinity",
    "draconic soul",
    "divine staff",
    "easter parasol",
    "bunny summoner",
    "fallen staff",
    "golden clockwork",
    "empyrean staff",
    "void guitar",
    "cloud weaver",
    "overdrive",
    "blossom guitar",
    "butterfly sword",
    "galaxy conqueror",
    "blossom conqueror",
    "world tour football",
    "dragonmaster scythe",
    "sunshine cello",
    "intergalactic sniper",
    "starweaver's globe",
    "silverweaver's globe",
    "blossom kunai",
    "shiro kunai",
    "frosted guitar",
    "oceanic trident",
    "wings of everlove",
    "spirit staff",
    "pirate banjo",
    "reaver scyte",
    "void kraken",
    "voidpunk axe"
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

Enabled = true,

Percent = 1

}


},


------------------------------------------------
-- Pets
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
    Min = 1,
    Max = 300
},

RAP = {

Enabled = true,

Percent = 1

}


},




------------------------------------------------
-- BOATS
------------------------------------------------

Boats = {


Enabled = true,

Name = {

    Enabled = true,

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

Percent = 5

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


}



},




------------------------------------------------
-- SERVER
------------------------------------------------

Server = {


AutoHop = true,


MinPlayer = 1,


MaxPlayer = 20,


HopDelay = 1


}



}



------------------------------------------------
-- STATE
------------------------------------------------

local FoundItems = {}

local UsedUUID = {}

local FoundCount = 0




------------------------------------------------
-- DEBUG PRINT
------------------------------------------------

local function DebugPrint(...)

    if Config.Debug then

        print(...)

    end

end





------------------------------------------------
-- CLEAN
------------------------------------------------

local function Clean(text)

    if not text then

        return ""

    end


    return tostring(text)
    :lower()

end





------------------------------------------------
-- CLEAN RAP NAME
------------------------------------------------

local function CleanRAPName(name)


    if not name then

        return ""

    end



    local result =
    tostring(name)



    local remove = {

        "Big Shiny ",
        "Big ",
        "Shiny "

    }



    for _,v in ipairs(remove) do

        result =
        result:gsub(
            "^"..v,
            ""
        )

    end



    return result


end




------------------------------------------------
-- GET RAP FINAL ID BASED
------------------------------------------------

local function GetRAP(itemType,itemName,item)


    if not RAPController then

        print("[RAP] CONTROLLER NIL")

        return nil

    end



    local ok,rap =
    pcall(function()



        ----------------------------------------
        -- PET FINAL FIX
        ----------------------------------------

        if itemType == "Pets"
        and item.ItemId
        then

            return RAPController:GetRAP(
                "Pets",
                item.ItemId
            )

        end



        ----------------------------------------
        -- TRY ITEM ID FIRST
        ----------------------------------------

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



        ----------------------------------------
        -- FALLBACK NAME
        ----------------------------------------

        return RAPController:GetRAP(
            itemType,
            CleanRAPName(
                item.BaseName
                or itemName
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



    if ok then

        return rap

    end



    return nil


end
------------------------------------------------
-- GET CATEGORY
------------------------------------------------

local function GetCategory(itemType)


    return Config.Items[itemType]


end






------------------------------------------------
-- NAME FILTER
------------------------------------------------
local function CheckFilter(value,cfg)


    if not cfg
    or not cfg.Enabled
    then

        return true

    end



    if #(cfg.List or {}) == 0 then

        return true

    end



    value =
    Clean(value)



    local found=false



    for _,v in ipairs(cfg.List) do


        local text =
        Clean(v)



        if cfg.Match=="Exact" then

            found =
            value == text


        elseif cfg.Match=="Contains" then

            found =
            value:find(text,1,true)
            ~=nil


        elseif cfg.Match=="StartsWith" then

            found =
            value:sub(1,#text)==text


        elseif cfg.Match=="EndsWith" then

            found =
            value:sub(-#text)==text


        end



        if found then
            break
        end


    end



    if cfg.Mode=="Blacklist" then

        return not found

    end



    return found


end
------------------------------------------------
-- MUTATION FILTER
------------------------------------------------
local function CheckMutation(mutation,cfg)

    if not cfg
    or not cfg.Enabled
    then
        return true
    end


    mutation = Clean(mutation)



    -- wajib mutation
    if cfg.Require
    and (
        mutation == ""
        or mutation == "normal"
        or mutation == "nill"
    )
    then

        return false

    end



    for _,bad in ipairs(cfg.List or {}) do


        if cfg.Match == "Exact" then

            if mutation == Clean(bad) then

                if cfg.Mode == "Blacklist" then
                    return false
                end

            end


        elseif cfg.Match == "Contains" then

            if mutation:find(
                Clean(bad),
                1,
                true
            )
            then

                if cfg.Mode == "Blacklist" then
                    return false
                end

            end

        end


    end



    return true

end
------------------------------------------------
-- PRICE FILTER
------------------------------------------------

local function CheckPrice(item)

    local category = GetCategory(item.ItemType)

    if not category then
        return true
    end

    local cfg = category.Price

    if not cfg or not cfg.Enabled then
        return true
    end

    local price = tonumber(item.Price) or 0

    if cfg.Min and price < cfg.Min then
        DebugPrint("[PRICE TOO LOW]", item.Name, price)
        return false
    end

    if cfg.Max and price > cfg.Max then
        DebugPrint("[PRICE TOO HIGH]", item.Name, price)
        return false
    end

    return true

end


------------------------------------------------
-- RAP FILTER
------------------------------------------------

local function CheckRAP(item)


    local category =
    GetCategory(
        item.ItemType
    )


    if not category then

        return true

    end



    if not category.RAP
    or not category.RAP.Enabled
    then

        return true

    end




    print(
    "[RAP TRY]",
    item.ItemType,
    "Display:",
    item.Name,
    "Base:",
    item.BaseName,
    "Raw:",
    item.RawName,
    "ID:",
    item.ItemId
)


local rap =
GetRAP(
    item.ItemType,
    item.Name,
    item
)


print(
    "[RAP RESULT]",
    rap
)



    if not rap then

        return true

    end



    item.RAP = rap



    local percent =
    category.RAP.Percent or 1



    local limit =
    rap *
    (
        100-percent
    )
    /
    100



    if item.Price > limit then

        DebugPrint(

            "[OVER RAP]",

            item.Name,

            item.Price,

            rap

        )


        return false

    end




    item.UnderRap =
    math.floor(

        (
            1 -
            item.Price / rap
        )
        *
        100

    )



    return true


end






------------------------------------------------
-- CATEGORY FILTER
------------------------------------------------
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



    -----------------------------
    -- NAME
    -----------------------------

    if category.Name then


        if not CheckFilter(
            item.BaseName ~= "" and item.BaseName or item.Name,
            category.Name
        )
        then

            DebugPrint(
                "[NAME FAIL]",
                item.Name
            )

            return false

        end

    elseif category.FilterName then


        if not CheckNameFilter(
            item,
            category.Names
        )
        then

            DebugPrint(
                "[NAME FAIL]",
                item.Name
            )

            return false

        end


    end



    -----------------------------
    -- VARIANT OPTIONAL
    -----------------------------

    if category.Variant then

        if not CheckFilter(
            item.Variant,
            category.Variant
        )
        then

            return false

        end

    end



    -----------------------------
    -- SIZE OPTIONAL
    -----------------------------

    if category.Size then

        if not CheckFilter(
            item.Size,
            category.Size
        )
        then

            return false

        end

    end



    return true


end


--================================================--
-- BOOTH SCANNER + ITEM PARSER
--================================================--



------------------------------------------------
-- GET SELLER
------------------------------------------------

local function GetSeller(userId)


    if not userId then

        return "Unknown"

    end



    local success,name =
    pcall(function()

        return Players:
        GetNameFromUserIdAsync(
            userId
        )

    end)



    if success then

        return name

    end



    return tostring(userId)


end






------------------------------------------------
-- GET TEXT
------------------------------------------------

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






------------------------------------------------
-- GET IMAGE
------------------------------------------------

local function GetImage(frame)


    local image


    pcall(function()


        image =
        frame:
        FindFirstChildWhichIsA(
            "ImageLabel",
            true
        )


    end)



    if image then


        local id =
        image.Image



        if id then


            return id:gsub(
                "rbxassetid://",
                ""
            )


        end


    end



    return nil


end







------------------------------------------------
-- PARSE ITEM DETAIL 
------------------------------------------------

local function ParseItemDetail(item,inside)



    item.BaseName =
    item.Name



    item.Size = ""



    ------------------------------------------------
    -- SIZE
    ------------------------------------------------

    local bigFrame =
    inside:FindFirstChild(
        "BigFrame",
        true
    )



    if bigFrame
    and bigFrame.Visible
    then


        local label =
        bigFrame:FindFirstChild(
            "Label",
            true
        )



        if label then


            item.Size =
            label.Text


        else


            item.Size =
            "Big"


        end


    end





    ------------------------------------------------
    -- MUTATION
    -- VariantLabel
    ------------------------------------------------

    local mutation =
    inside:FindFirstChild(
        "VariantLabel",
        true
    )



    if mutation
    and mutation.Visible
    then


        local text =
        GetText(mutation)



        if text ~= "" then


            item.Mutation =
            text


        end


    end





    ------------------------------------------------
    -- VARIANT
    -- ShinyFrame
    ------------------------------------------------

    local shiny =
    inside:FindFirstChild(
        "ShinyFrame",
        true
    )



    if shiny
    and shiny.Visible
    then


        local label =
        shiny:FindFirstChild(
            "Label",
            true
        )



        if label then


            item.Variant =
            label.Text


        end


    end






    ------------------------------------------------
    -- NAME PREFIX
    ------------------------------------------------

    local name =
    item.Name



    local lower =
    name:lower()




    if lower:find(
        "^big shiny "
    )
    then


        if item.Size == "" then

            item.Size="Big"

        end



        if item.Mutation == "" then

            item.Mutation="Shiny"

        end



        item.BaseName =
        name:gsub(
            "^[Bb][Ii][Gg]%s+[Ss][Hh][Ii][Nn][Yy]%s+",
            ""
        )




    elseif lower:find(
        "^big "
    )
    then



        if item.Size == "" then

            item.Size="Big"

        end



        item.BaseName =
        name:gsub(
            "^[Bb][Ii][Gg]%s+",
            ""
        )




    elseif lower:find(
        "^shiny "
    )
    then



        if item.Mutation=="" then

            item.Mutation="Shiny"

        end



        item.BaseName =
        name:gsub(
            "^[Ss][Hh][Ii][Nn][Yy]%s+",
            ""
        )



    end




end







------------------------------------------------
-- GET WEIGHT
------------------------------------------------

local function GetWeight(item,inside)



    if item.ItemType ~= "Fish" then

        return ""

    end




    local frame =
    inside:FindFirstChild(
        "WeightFrame",
        true
    )



    if frame
    and frame.Visible
    then



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



        if text then

            return text.Text

        end


    end



    return "-"

end






------------------------------------------------
-- GET ORIGINAL ITEM NAME
------------------------------------------------

local function GetOriginalName(itemType,itemId)


    if not itemId then
        return nil
    end


    local success,result =
    pcall(function()


        return RAPController:GetItemName(
            itemType,
            itemId
        )
        


    end)


    if success then

        return result

    end


    return nil

end



------------------------------------------------
-- CHECK ITEM
------------------------------------------------

local function CheckItem(frame,booth)



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



        ItemId = frame:GetAttribute("ItemId"),
        RawName = "",



        Image =
        GetImage(frame),



        Name="",


        BaseName="",


        Variant="",


        Mutation="",


        Size="",


        Weight="",


        Price =
        buy
        and
        buy:GetAttribute(
            "LastKnownPrice"
        )
        or 0,


        RAP=nil,


        UnderRap=nil


    }







    ------------------------------------------------
    -- NAME
    ------------------------------------------------

    local label =
    inside:FindFirstChild(
        "Label",
        true
    )



    if label then


        item.Name =
        GetText(label)


    end




    if item.Name=="" then

        return

    end







    ------------------------------------------------
    -- PARSE
    ------------------------------------------------

    ParseItemDetail(
        item,
        inside
    )

if item.ItemType == "Pets" then


    local original =
    GetOriginalName(
        item.ItemType,
        item.ItemId
    )


    if original then

        item.RawName = original
        print(
    "[PET NAME DEBUG]",
    item.Name,
    item.ItemId,
    item.RawName
)

    else

        item.RawName = item.BaseName

    end


end

    item.Weight =
    GetWeight(
        item,
        inside
    )







    ------------------------------------------------
    -- FILTER
    ------------------------------------------------

    if not CheckCategory(item)
    then

        return

    end




    local category =
    GetCategory(
        item.ItemType
    )



    if category.Mutation then

    if not CheckMutation(
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

end

if not CheckPrice(item) then
    return
end

if not CheckRAP(item)
then
    return
end







    ------------------------------------------------
    -- SELLER
    ------------------------------------------------

    item.Seller =
    GetSeller(
        booth:GetAttribute(
            "Owner"
        )
    )





    if uuid then

        UsedUUID[uuid]=true

    end





    table.insert(
        FoundItems,
        item
    )



    FoundCount += 1





    print("================")
    print("FOUND",item.Name)
    print("TYPE",item.ItemType)
    print("BASE",item.BaseName)
    print("VARIANT",item.Variant)
    print("MUTATION",item.Mutation)
    print("SIZE",item.Size)
    print("WEIGHT",item.Weight)
    print("PRICE",item.Price)
    print("RAP",item.RAP)
    print("================")



end







------------------------------------------------
-- SCAN BOOTHS
------------------------------------------------

local function ScanBooths()



    local trade =
    workspace:
    FindFirstChild(
        "Islands"
    )



    if not trade then

        return

    end



    trade =
    trade:
    FindFirstChild(
        "TradePlaza",
        true
    )



    if not trade then

        return

    end





    local booths =
    trade:
    FindFirstChild(
        "Booths"
    )



    if not booths then

        return

    end





    for _,booth in ipairs(
        booths:GetChildren()
    )
    do


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


                    for _,frame in ipairs(
                        items:GetChildren()
                    )
                    do


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
-- WEBHOOK SYSTEM AUTO SPLIT
--================================================--

local function BuildItemText(item)


    local text =

    "━━━━━━━━━━━━━━\n\n"


    text =
    text
    ..
    "🎣 **"
    ..
    tostring(item.Name or "-")
    ..
    "**\n\n"



    text =
    text
    ..
    "**Seller**\n"
    ..
    tostring(item.Seller or "-")
    ..
    "\n\n"



    text =
    text
    ..
    "Type : "
    ..
    tostring(item.ItemType or "-")
    ..
    "\n"



    ------------------------------------------------
    -- VARIANT
    ------------------------------------------------

    if item.Variant
    and item.Variant ~= ""
    then

        text =
        text
        ..
        "Variant : "
        ..
        item.Variant
        ..
        "\n"

    end



    ------------------------------------------------
    -- MUTATION
    ------------------------------------------------

    if item.Mutation
    and item.Mutation ~= ""
    then

        text =
        text
        ..
        "Mutation : "
        ..
        item.Mutation
        ..
        "\n"

    end




    ------------------------------------------------
    -- SIZE
    ------------------------------------------------

    if item.Size
    and item.Size ~= ""
    then

        text =
        text
        ..
        "Size : "
        ..
        item.Size
        ..
        "\n"

    end




    ------------------------------------------------
    -- WEIGHT
    ------------------------------------------------

    if item.Weight
    and item.Weight ~= ""
    then

        text =
        text
        ..
        "Weight : "
        ..
        item.Weight
        ..
        "\n"

    end




    text =
    text
    ..
    "\nPrice : "
    ..
    tostring(item.Price or 0)
    ..
    "\n"



    text =
    text
    ..
    "RAP : "
    ..
    tostring(item.RAP or "-")
    ..
    "\n"



    if item.UnderRap then


        text =
        text
        ..
        "Under RAP : "
        ..
        tostring(item.UnderRap)
        ..
        "%\n"


    end



    text =
    text
    ..
    "\n"



    return text


end






------------------------------------------------
-- SPLIT ITEM AUTO
------------------------------------------------

local function SplitItems(items)


    local result = {}

    local buffer = ""



    for _,item in ipairs(items)
    do



        local itemText =
        BuildItemText(item)



        -- Discord safe limit
        if
        (#buffer + #itemText)
        >
        3000
        then


            table.insert(
                result,
                buffer
            )


            buffer =
            itemText



        else



            buffer =
            buffer
            ..
            itemText



        end



    end





    if buffer ~= ""
    then


        table.insert(
            result,
            buffer
        )


    end



    return result


end







------------------------------------------------
-- CREATE EMBED
------------------------------------------------

local function CreateEmbed(
    items,
    part,
    totalPart
)


    local PlaceId = game.PlaceId


    local JobId =
    game.JobId



    local joinLink =

    "https://www.roblox.com/games/start?placeId="
    ..
    PlaceId
    ..
    "&gameInstanceId="
    ..
    JobId






    return {


        title =

        "🎣 W FINDER FOUND ("
        ..
        #items
        ..
        " ITEMS)"
        ..
        (
            totalPart > 1
            and
            " PART "..part.."/"..totalPart
            or
            ""
        ),



        color = 65280,



        fields = {



            {

                name =
                "Server",


                value =

                tostring(
                    #Players:GetPlayers()
                )
                ..
                "/"
                ..
                tostring(
                    Players.MaxPlayers
                ),


                inline=false

            },





            {

                name =
                "JobId",


                value =


                "📋 Copy mobile:\n"
                ..
                "`"
                ..
                JobId
                ..
                "`\n\n"


                ..


                "📋 Copy desktop:\n"
                ..
                "```"
                ..
                JobId
                ..
                "```",



                inline=false


            },





            {

                name =
                "Join Server",


                value =

                "🔗 "
                ..
                joinLink,


                inline=false


            },





            {

                name =
                "Items",


                value =

                SplitItems(items)[part]
                or
                "-",


                inline=false


            }



        },



        footer = {


            text =

            "W FINDER  | JobId : "
            ..
            JobId


        }


    }


end








------------------------------------------------
-- SEND WEBHOOK
------------------------------------------------

------------------------------------------------
-- WEBHOOK BY CATEGORY
------------------------------------------------

local function SendWebhook(items)


    local grouped = {}



    for _,item in ipairs(items) do


        local typeName =
        item.ItemType



        if Config.Webhook[typeName]
        then


            if not grouped[typeName]
            then

                grouped[typeName]={}

            end



            table.insert(
                grouped[typeName],
                item
            )


        end


    end





    for itemType,list in pairs(grouped)
    do



        local webhook =
        Config.Webhook[itemType]



        if webhook
        and webhook ~= ""
        then



            local itemText = ""




            for _,item in ipairs(list)
            do



                itemText =
                itemText
                ..
                "━━━━━━━━━━━━━━\n\n"



                itemText =
                itemText
                ..
                "🎣 **"
                ..
                tostring(item.Name)
                ..
                "**\n\n"



                itemText =
                itemText
                ..
                "**Seller**\n"
                ..
                tostring(item.Seller or "-")
                ..
                "\n\n"



                itemText =
                itemText
                ..
                "Type : "
                ..
                item.ItemType
                ..
                "\n"



                if item.Variant
                and item.Variant ~= ""
                then

                    itemText =
                    itemText
                    ..
                    "Variant : "
                    ..
                    item.Variant
                    ..
                    "\n"

                end



                if item.Mutation
                and item.Mutation ~= ""
                then

                    itemText =
                    itemText
                    ..
                    "Mutation : "
                    ..
                    item.Mutation
                    ..
                    "\n"

                end



                if item.Size
                and item.Size ~= ""
                then

                    itemText =
                    itemText
                    ..
                    "Size : "
                    ..
                    item.Size
                    ..
                    "\n"

                end



                if item.Weight
                and item.Weight ~= ""
                and item.Weight ~= "-"
                then

                    itemText =
                    itemText
                    ..
                    "Weight : "
                    ..
                    item.Weight
                    ..
                    "\n"

                end




                itemText =
                itemText
                ..
                "\nPrice : "
                ..
                tostring(item.Price or 0)
                ..
                "\n"



                itemText =
                itemText
                ..
                "RAP : "
                ..
                tostring(item.RAP or "-")
                ..
                "\n"



                if item.UnderRap then


                    itemText =
                    itemText
                    ..
                    "Under RAP : "
                    ..
                    item.UnderRap
                    ..
                    "%\n"


                end



                itemText =
                itemText
                ..
                "\n"


            end







            local joinLink =

            "https://www.roblox.com/games/start?placeId="
            ..
            game.PlaceId
            ..
            "&gameInstanceId="
            ..
            game.JobId







            local payload = {


                username =
                "W FINDER",



                embeds = {


                    {


                        title =

                        "🎣 W FINDER FOUND "
                        ..
                        #list
                        ..
                        " "
                        ..
                        string.upper(itemType),



                        color =
                        65280,



                        fields = {



                            {

                                name="Server",

                                value =
                                #Players:GetPlayers()
                                ..
                                "/"
                                ..
                                Players.MaxPlayers,

                                inline=false

                            },



                            {

                                name="JobId",

                                value =

                                "📋 Copy mobile:\n"
                                ..
                                "`"
                                ..
                                game.JobId
                                ..
                                "`\n\n"

                                ..

                                "📋 Copy desktop:\n"
                                ..
                                "```"
                                ..
                                game.JobId
                                ..
                                "```",

                                inline=false

                            },



                            {

                                name="Join Server",

                                value =
                                "🔗 "
                                ..
                                joinLink,

                                inline=false

                            },



                            {

                                name="Items",

                                value =
                                itemText:sub(1,1024),

                                inline=false

                            }


                        },



                        footer={

                            text =
                            "W FINDER"

                        }


                    }


                }


            }




            local body =
            HttpService:JSONEncode(
                payload
            )




            local req =
            request
            or http_request
            or syn.request




            if req then


                req({

                    Url =
                    webhook,


                    Method =
                    "POST",


                    Headers =
                    {

                        ["Content-Type"]=
                        "application/json"

                    },


                    Body =
                    body


                })



                print(
                    "WEBHOOK SENT",
                    itemType,
                    #list
                )


            end



        end



    end



end





--================================================--

-- SERVER CACHE + SCRAPE + SERVER HOP
--================================================--


------------------------------------------------
-- SERVER CACHE
------------------------------------------------

local ServerCacheFile =
"JP_FINDER_V7_2_SERVERS.json"



local ServerList = {}

local TriedServers = {}






------------------------------------------------
-- SAVE CACHE
------------------------------------------------

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







------------------------------------------------
-- LOAD CACHE
------------------------------------------------

local function LoadServerCache()



    if not readfile
    or not isfile
    then

        return

    end




    if not isfile(
        ServerCacheFile
    )
    then

        return

    end





    local success,data =

    pcall(function()


        return HttpService:JSONDecode(

            readfile(
                ServerCacheFile
            )

        )


    end)





    if success
    and data
    then


        ServerList =
        data.Servers
        or {}



        TriedServers =
        data.Tried
        or {}



        print(

            "[CACHE LOADED]",

            #ServerList

        )


    end



end







------------------------------------------------
-- SERVER USED CHECK
------------------------------------------------

local function IsServerUsed(id)


    return TriedServers[id]
    == true


end







------------------------------------------------
-- SCRAPE SERVER LIST
------------------------------------------------

local function GetAllServers()



    print(
        "=== SCRAPE SERVER ==="
    )



    local servers = {}

    local cursor = ""

    local page = 0






    while true do



        local url =


        "https://games.roblox.com/v1/games/"
        ..
        tostring(PlaceId)
        ..
        "/servers/Public?sortOrder=Desc&limit=100"





        if cursor ~= "" then


            url =

            url
            ..
            "&cursor="
            ..
            cursor


        end






        local success,response =


        pcall(function()


            return game:HttpGet(
                url
            )


        end)





        if not success then


            warn(
                "[SCRAPE ERROR]"
            )


            break


        end





        local decode,data =


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





        for _,server in ipairs(
            data.data
        )
        do



            if

            server.id ~= game.JobId

            and

            server.playing >= Config.Server.MinPlayer

            and

            server.playing <= Config.Server.MaxPlayer

            and

            server.playing < server.maxPlayers

            and

            not IsServerUsed(
                server.id
            )

            then



                table.insert(

                    servers,

                    server.id

                )


            end


        end





        page += 1





        if page >= 5 then

            break

        end





        if not data.nextPageCursor then

            break

        end




        cursor =
        data.nextPageCursor




        task.wait(
            0.5
        )



    end






    print(

        "[SERVER FOUND]",

        #servers

    )



    return servers



end







------------------------------------------------
-- GET NEXT SERVER
------------------------------------------------

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


        TriedServers[serverId]=true


        SaveServerCache()



    end





    return serverId



end







------------------------------------------------
-- SERVER HOP
------------------------------------------------

local function ServerHop()



    if not Config.Server.AutoHop then

        return

    end





    print(
        "================="
    )

    print(
        "START SERVER HOP"
    )






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






    local success,err =

    pcall(function()



        TeleportService:

        TeleportToPlaceInstance(

            PlaceId,

            target,

            LocalPlayer

        )



    end)







    if not success then


        warn(

            "[TELEPORT ERROR]",

            err

        )


        task.wait(
            3
        )


        ServerHop()



    end




end







------------------------------------------------
-- TELEPORT FAILED
------------------------------------------------

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



end)





--================================================--
-- MAIN LOOP + START SYSTEM
--================================================--


------------------------------------------------
-- RESET SCAN
------------------------------------------------

local function ResetScan()

    table.clear(
        FoundItems
    )


    table.clear(
        UsedUUID
    )


    FoundCount = 0


end





------------------------------------------------
-- SERVER INFO
------------------------------------------------

local function GetServerInfo()


    return {

        JobId =
        game.JobId,


        PlaceId =
        PlaceId,


        Players =
        #Players:GetPlayers(),


        MaxPlayers =
        game:GetService("Players").MaxPlayers


    }


end






------------------------------------------------
-- JOIN SERVER LINK
------------------------------------------------

local function GetJoinLink()


    return

    "https://www.roblox.com/games/"
    ..
    PlaceId
    ..
    "?gameInstanceId="
    ..
    game.JobId


end






------------------------------------------------
-- WEBHOOK FULL FIX
------------------------------------------------
local function GetWebhook(itemType)

    return Config.Webhook[itemType]

end
------------------------------------------------
-- WEBHOOK TYPE SPLIT FIX
------------------------------------------------

local function GetWebhook(itemType)

    return Config.Webhook[itemType]

end



local function BuildItemText(item)


    local text =

    "━━━━━━━━━━━━━━\n\n"


    text =
    text
    .."🎣 **"
    ..tostring(item.Name or "-")
    .."**\n\n"



    text =
    text
    .."**Seller**\n"
    ..tostring(item.Seller or "-")
    .."\n\n"



    text =
    text
    .."Type : "
    ..tostring(item.ItemType or "-")
    .."\n\n"



    if item.Variant
    and item.Variant ~= ""
    then

        text =
        text
        .."Variant : "
        ..item.Variant
        .."\n"

    end



    if item.Mutation
    and item.Mutation ~= ""
    then

        text =
        text
        .."Mutation : "
        ..item.Mutation
        .."\n"

    end



    if item.Size
    and item.Size ~= ""
    then

        text =
        text
        .."Size : "
        ..item.Size
        .."\n"

    end



    if item.Weight
    and item.Weight ~= ""
    and item.Weight ~= "-"
    then

        text =
        text
        .."Weight : "
        ..item.Weight
        .."\n"

    end



    text =
    text
    .."\nPrice : "
    ..tostring(item.Price or 0)
    .."\n"



    text =
    text
    .."RAP : "
    ..tostring(item.RAP or "-")
    .."\n"



    if item.UnderRap then

        text =
        text
        .."Under RAP : "
        ..tostring(item.UnderRap)
        .."%\n"

    end


    text =
    text
    .."\n"


    return text


end





local function SendWebhook(items)



    local grouped = {}



    for _,item in ipairs(items) do


        local hook =
        GetWebhook(
            item.ItemType
        )



        if hook then


            if not grouped[hook] then

                grouped[hook]={}

            end


            table.insert(
                grouped[hook],
                item
            )


        end


    end





    for webhook,list in pairs(grouped) do



        local itemText = ""



        for _,item in ipairs(list) do


            local add =
            BuildItemText(item)



            -- discord field max
            if #itemText + #add > 900 then

                break

            end



            itemText =
            itemText
            ..add



        end





        local joinLink =

        "https://www.roblox.com/games/start?placeId="
        ..
        game.PlaceId
        ..
        "&gameInstanceId="
        ..
        game.JobId





        local payload = {


            username =
            "W FINDER",


            embeds =
            {


                {


                    title =

                    "🎣 W FINDER FOUND ("
                    ..
                    #list
                    ..
                    " ITEMS)",



                    color =
                    65280,



                    fields =
                    {


                        {


                            name =
                            "Server",

                            value =

                            tostring(
                                #Players:GetPlayers()
                            )
                            ..
                            "/"
                            ..
                            tostring(
                                Players.MaxPlayers
                            ),

                            inline=false

                        },



                        {


                            name =
                            "JobId",

                            value =

                            "📋 Copy mobile:\n"
                            ..
                            "`"
                            ..
                            game.JobId
                            ..
                            "`\n\n"
                            ..
                            "📋 Copy desktop:\n"
                            ..
                            "```"
                            ..
                            game.JobId
                            ..
                            "```",

                            inline=false


                        },



                        {


                            name =
                            "Join Server",

                            value =

                            "🔗 "
                            ..
                            joinLink,

                            inline=false


                        },



                        {


                            name =
                            "Items",

                            value =

                            itemText,

                            inline=false


                        }



                    },



                    footer = {

                        text =
                        "W FINDER | "
                        ..
                        game.JobId

                    }


                }


            }


        }





        local body =
        HttpService:JSONEncode(
            payload
        )




        local req =
        request
        or http_request
        or syn.request




        if req then


            req({

                Url =
                webhook,


                Method =
                "POST",


                Headers =
                {

                    ["Content-Type"] =
                    "application/json"

                },


                Body =
                body

            })



            print(
            "WEBHOOK SENT",
            #list,
            webhook
            )


        end



    end



end

------------------------------------------------
-- RUN SCAN
------------------------------------------------

local function RunScan()



    print(
        "======================"
    )


    print(
        "🎣 START SCAN "
    )



    print(
        "JOB:",
        game.JobId
    )





    ResetScan()






    task.wait(
        Config.LoadDelay
    )





    print(
        "[SCAN BOOTH]"
    )



    local success,err =

    pcall(function()


        ScanBooths()


    end)





    if not success then


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







------------------------------------------------
-- MAIN FINDER LOOP
------------------------------------------------

local function StartFinder()



    print(
        "🎣 W FINDER  START"
    )




    while true do





        local success,err =

        pcall(function()


            RunScan()


        end)





        if not success then


            warn(
                "[MAIN ERROR]",
                err
            )


        end





        ------------------------------------------------
        -- AUTO HOP
        ------------------------------------------------

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





        task.wait(
            10
        )



    end



end







------------------------------------------------
-- INIT
------------------------------------------------

LoadServerCache()





task.spawn(function()


    StartFinder()


end)





print(
"🎣 W FINDER FISHIT  READY"
)
