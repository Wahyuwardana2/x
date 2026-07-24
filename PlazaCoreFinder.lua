--================================================--
-- JP FINDER FISCH FINAL V3
-- WITHERING CORE HUNTER
-- PART 1/3
--================================================--

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer



------------------------------------------------
-- CONFIG
------------------------------------------------

local Config = {

    Webhook =
    "https://discordapp.com/api/webhooks/1516432952370663529/Fp2ZgaPztDl4CxMS3OyEHqKuG_FoWVz1TOjn1ou_PfhjaWTwsp3ozuOAV9KsxIWQQncP",


    TargetItem =
    "Withering Core",


    AutoHop = true,


    MinPlayer = 1,

    MaxPlayer = 21,


    LoadDelay = 10,


    StayTime = 5,


    HopDelay = 5

}



------------------------------------------------
-- STATE
------------------------------------------------

local FoundItem = false

local FoundCount = 0

local FoundItems = {}

local UsedUUID = {}



------------------------------------------------
-- SERVER INFO
------------------------------------------------

local PlaceId = 79378095465365



------------------------------------------------
-- CLEAN TEXT
------------------------------------------------

local function Clean(text)

    if not text then
        return ""
    end

    return tostring(text):lower()

end



------------------------------------------------
-- GET SELLER
------------------------------------------------

local function GetSeller(userId)


    if not userId then

        return "Unknown"

    end



    local success,name =
    pcall(function()

        return Players:GetNameFromUserIdAsync(
            userId
        )

    end)



    if success then

        return name

    end



    return tostring(userId)

end




------------------------------------------------
-- DISCORD WEBHOOK
------------------------------------------------

local function SendWebhook(items)


    if Config.Webhook == "" then

        warn(
            "Webhook kosong"
        )

        return

    end



    local serverLink =

    "https://www.roblox.com/games/"
    ..
    PlaceId
    ..
    "?gameInstanceId="
    ..
    game.JobId



    local text = ""



    for _,item in ipairs(items) do


        text = text

        .."🎣 **"
        ..item.Item
        .."**\n"

        .."Size: "
        ..item.Size 
        .."\n"

        .."Mutation: "
        ..item.Mutation
        .."\n"

        .."Variant: "
        ..item.Variant
        .."\n"

        .."Weight: "
        ..tostring(item.Weight ~= "" and item.Weight or "-")
        .."\n"

        .."Price: "
        ..tostring(item.Price)
        .."\n"

        .."Seller: "
        ..item.Seller
        .."\n\n"


    end



    local payload = {


        embeds = {


            {

                title =
                "🎣 JP FINDER FOUND ITEM",


                color = 65280,


                fields = {


                    {

                        name =
                        "Total",

                        value =
                        tostring(#items)

                    },


                    {

                        name =
                        "Items",

                        value =
                        text:sub(1,1024)

                    },


                    {

                        name =
                        "Server",

                        value =
                        serverLink

                    }


                }


            }


        }


    }



    local body =
    HttpService:JSONEncode(
        payload
    )



    local requestFunc =
    request
    or http_request
    or syn.request



    if requestFunc then


        requestFunc({

            Url = Config.Webhook,

            Method = "POST",

            Headers = {

                ["Content-Type"] =
                "application/json"

            },

            Body = body

        })


    else


        HttpService:PostAsync(

            Config.Webhook,

            body,

            Enum.HttpContentType.ApplicationJson

        )


    end



    print(
        "[WEBHOOK SENT]"
    )


end





------------------------------------------------
-- CHECK ITEM
------------------------------------------------

local function CheckItem(frame,booth)



    local uuid =
    frame:GetAttribute(
        "ItemUUID"
    )



    if uuid and UsedUUID[uuid] then

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


        Name = "",

        Size = "",

        Mutation = "",

        Variant = "",

        Weight = "",


        Price =
        buy and
        buy:GetAttribute(
            "LastKnownPrice"
        )
        or 0


    }





    ------------------------------------------------
    -- ITEM NAME
    ------------------------------------------------


    local label =
    inside:FindFirstChild(
        "Label",
        true
    )



    if label
    and label:IsA("TextLabel")
    then


        item.Name =
        label.Text


    end




    if item.Name == "" then

        return

    end




    ------------------------------------------------
    -- FILTER ITEM
    ------------------------------------------------

    if Clean(item.Name)
    ~=
    Clean(Config.TargetItem)
    then

        return

    end




    -- BARU LOCK UUID
    if uuid then

        UsedUUID[uuid]=true

    end


------------------------------------------------
-- WEIGHT
------------------------------------------------

local weightFrame = inside:FindFirstChild("WeightFrame", true)

if weightFrame and weightFrame.Visible then
    local weightLabel = weightFrame:FindFirstChild("Label", true)

    if weightLabel and weightLabel:IsA("TextLabel") then
        item.Weight = weightLabel.Text
    end
end


------------------------------------------------
-- SIZE
------------------------------------------------

local bigFrame = inside:FindFirstChild("BigFrame", true)

if bigFrame and bigFrame.Visible then
    local sizeLabel = bigFrame:FindFirstChild("Label", true)

    if sizeLabel and sizeLabel:IsA("TextLabel") then
        item.Size = sizeLabel.Text
    else
        item.Size = "Big"
    end
end


    
    ------------------------------------------------
    -- MUTATION
    ------------------------------------------------


    local mutation =
    inside:FindFirstChild(
        "VariantLabel",
        true
    )



    if mutation
    and mutation:IsA("TextLabel")
    and mutation.Visible
    then


        item.Mutation =
        mutation.Text


    end





    ------------------------------------------------
    -- VARIANT
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



        if label
        and label:IsA("TextLabel")
        then

            item.Variant =
            label.Text

        end


    end





    ------------------------------------------------
    -- MUTATION FILTER
    ------------------------------------------------

    local blacklist = {


        "ghost",

        "sandy",

        "stone",

        "albino",

        "shiny"


    }





    if Clean(item.Mutation)=="" 
    or Clean(item.Mutation)=="normal"
    then


        return


    end




    for _,bad in ipairs(blacklist) do


        if Clean(item.Mutation):find(bad)
        then

            return

        end


    end





    ------------------------------------------------
    -- SELLER
    ------------------------------------------------

    local owner =
    booth:GetAttribute(
        "Owner"
    )



    local seller =
    GetSeller(owner)




    ------------------------------------------------
    -- FOUND
    ------------------------------------------------

    FoundItem = true

    FoundCount += 1



    print("================")
    print("FOUND",item.Name)
    print("Mutation",item.Mutation)
    print("Variant",item.Variant)
    print("Price",item.Price)
    print("Seller",seller)
    print("================")




    table.insert(
        FoundItems,
        {

            Item=item.Name,

            Size = item.Size,

            Mutation=item.Mutation,

            Variant=item.Variant,

            Weight = item.Weight,

            Price=item.Price,

            Seller=seller

        }
    )



end

--================================================--
-- JP FINDER FISCH FINAL V3
-- PART 2/3
-- SCAN + SERVER CACHE + SCRAPE
--================================================--


------------------------------------------------
-- SCAN ALL BOOTH
------------------------------------------------

local function ScanBooths()


    local success,err =
    pcall(function()


        local booths =
        workspace
        .Islands
        .TradePlaza
        .Booths



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


    end)



    if not success then

        warn(
            "[SCAN BOOTH ERROR]",
            err
        )

    end


end







------------------------------------------------
-- SERVER CACHE V3
------------------------------------------------

local ServerCacheFile =
"JP_FINDER_SERVERS_V3.json"



local ServerList = {}

local TriedServers = {}





------------------------------------------------
-- SAVE CACHE
------------------------------------------------

local function SaveServerCache()


    if not writefile then

        return

    end



    local data = {


        Servers =
        ServerList,


        Tried =
        TriedServers


    }



    writefile(

        ServerCacheFile,

        HttpService:JSONEncode(
            data
        )

    )



    print(

        "[CACHE SAVED]",
        "SERVERS:",
        #ServerList

    )


end






------------------------------------------------
-- LOAD CACHE
------------------------------------------------

local function LoadServerCache()



    if not readfile
    or not isfile
    or not isfile(ServerCacheFile)
    then


        print(
            "[CACHE EMPTY]"
        )


        return false


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

            "SERVER:",
            #ServerList

        )



        return true


    end



    return false


end







------------------------------------------------
-- CHECK SERVER ALREADY USED
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
        "=== SCRAPE SERVER LIST ==="
    )



    local servers = {}

    local cursor = ""





    while true do



        local url =

        "https://games.roblox.com/v1/games/"
        ..
        PlaceId
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





        local success,result =

        pcall(function()


            return game:HttpGet(
                url
            )


        end)





        if not success then


            warn(

                "[SCRAPE ERROR]",
                result

            )


            break


        end





        local decodeSuccess,data =

        pcall(function()


            return HttpService:JSONDecode(
                result
            )


        end)





        if not decodeSuccess
        or not data
        or not data.data
        then


            break


        end





        for _,server in ipairs(
            data.data
        )
        do



            if server.id ~= game.JobId

            and server.playing >= Config.MinPlayer

            and server.playing <= Config.MaxPlayer

            and server.playing < server.maxPlayers

            and not IsServerUsed(server.id)

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


--================================================--
-- JP FINDER FISCH FINAL V3
-- PART 3/3
-- SERVER HOP + START
--================================================--



------------------------------------------------
-- GET NEXT SERVER
------------------------------------------------

local function GetNextServer()

    -- kalau ServerList kosong, coba load cache
    if #ServerList == 0 then
        LoadServerCache()
    end

    -- kalau masih kosong, reset TriedServers lalu scrape ulang
    if #ServerList == 0 then
        print("[CACHE EMPTY] RESET TRIED SERVERS")

        TriedServers = {}

        if writefile and isfile and isfile(ServerCacheFile) then
            delfile(ServerCacheFile)
        end

        ServerList = GetAllServers()
    end

    -- kalau tetap tidak ada server
    if #ServerList == 0 then
        warn("[NO SERVER AVAILABLE]")
        return nil
    end

    -- ambil server pertama
    local serverId = table.remove(ServerList, 1)

    -- tandai sudah dicoba
    TriedServers[serverId] = true

    -- simpan cache
    SaveServerCache()

    return serverId
end






------------------------------------------------
-- SERVER HOP
------------------------------------------------

local function ServerHop()



    print(
        "===================="
    )

    print(
        "START SERVER HOP"
    )





    local target =

    GetNextServer()





    if not target then


        task.wait(
            Config.HopDelay
        )


        ServerList =
        GetAllServers()



        target =
        GetNextServer()



        if not target then


            warn(
                "NO TARGET SERVER"
            )


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
            Config.HopDelay
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
        Config.HopDelay
    )



    ServerHop()



end)








------------------------------------------------
-- START FINDER
------------------------------------------------

local function StartFinder()



    print(
        "🎣 JP FINDER START"
    )



    while true do



        ------------------------------------------------
        -- RESET DATA SERVER BARU
        ------------------------------------------------

        FoundItem = false

        FoundCount = 0


        table.clear(
            FoundItems
        )


        table.clear(
            UsedUUID
        )




        ------------------------------------------------
        -- WAIT LOADING GAME
        ------------------------------------------------

        print(
            "[WAIT]",
            Config.LoadDelay
        )


        task.wait(
            Config.LoadDelay
        )





        ------------------------------------------------
        -- SCAN
        ------------------------------------------------

        print(
            "[SCAN START]"
        )



        ScanBooths()



        print(
            "[SCAN FINISH]",
            FoundCount
        )







        ------------------------------------------------
        -- WEBHOOK
        ------------------------------------------------

        if FoundCount > 0 then



            print(
                "[FOUND ITEM]",
                FoundCount
            )



            SendWebhook(
                FoundItems
            )



            task.wait(
                Config.StayTime
            )


        else


            print(
                "[NO TARGET]"
            )


        end







        ------------------------------------------------
        -- AUTO HOP
        ------------------------------------------------

        if Config.AutoHop then



            print(
                "[NEXT SERVER AFTER]",
                Config.HopDelay
            )



            task.wait(
                Config.HopDelay
            )



            ServerHop()



            -- tunggu teleport
            break



        end



    end


end







------------------------------------------------
-- LOAD CACHE FIRST
------------------------------------------------

LoadServerCache()







------------------------------------------------
-- START
------------------------------------------------

task.spawn(function()

    StartFinder()

end)



print(
    "🎣 JP FINDER FISCH FINAL V3 LOADED"
)
