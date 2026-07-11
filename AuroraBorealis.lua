local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local placeId = game.PlaceId

local CHECK_INTERVAL = 10
local MAX_PLAYERS = 20

local hopping = false


local function getServerBrowserReplion()
    for _,v in pairs(getgc(true)) do
        if typeof(v) == "table" then
            if tostring(v) == "Replion<ServerBrowser>" then
                return v
            end
        end
    end
end


local function hasAurora(server)

    if not server.Events then
        return false
    end

    for _,event in pairs(server.Events) do
        
        if string.find(
            string.lower(event),
            "aurora"
        ) then
            return true
        end

    end

    return false
end


local function findAuroraServer()

    local replion = getServerBrowserReplion()

    if not replion then
        return nil
    end


    local servers = replion.Data.Servers

    for _,server in pairs(servers) do
        
        if server.JobId ~= game.JobId
        and server.Players < MAX_PLAYERS
        and hasAurora(server) then
            
            print("================")
            print("AURORA SERVER FOUND")
            print("JOBID:", server.JobId)
            print("PLAYERS:", server.Players)
            print("REGION:", server.Region)
            print("================")

            return server.JobId
        end

    end

    return nil
end



local function checkCurrentServer()

    local replion = getServerBrowserReplion()

    if not replion then
        return false
    end


    for _,server in pairs(replion.Data.Servers) do
        
        if server.JobId == game.JobId then
            
            if hasAurora(server) then
                
                print("CURRENT SERVER : AURORA ACTIVE")
                return true

            else
                
                print("CURRENT SERVER : NO AURORA")
                return false

            end
        end
    end

    return false
end



local function hopToAurora()

    if hopping then
        return
    end

    local jobId = findAuroraServer()

    if jobId then
        
        hopping = true

        print("TELEPORTING TO:", jobId)

        TeleportService:TeleportToPlaceInstance(
            placeId,
            jobId,
            player
        )

    else
        
        print("NO AURORA SERVER FOUND")

    end
end



while task.wait(CHECK_INTERVAL) do

    local active = checkCurrentServer()

    if not active then
        hopToAurora()
    end

end
