local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local placeId = game.PlaceId
local currentJobId = game.JobId

local MIN_PLAYER = 5
local MAX_PLAYER = 19

print("=== SERVER HOP DEBUG START ===")
print("PlaceId:", placeId)
print("Current JobId:", currentJobId)

while true do
    print("\n[STEP] Ambil server list...")

    local success, result = pcall(function()
        return game:HttpGet("https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100")
    end)

    if not success then
        warn("[ERROR] Gagal ambil server list!")
        wait(3)
        continue
    end

    print("[OK] Server list berhasil diambil")

    local data = HttpService:JSONDecode(result)

    if not data or not data.data then
        warn("[ERROR] Data server kosong / invalid")
        wait(3)
        continue
    end

    print("[INFO] Total server ditemukan:", #data.data)

    local found = false

    for i, server in pairs(data.data) do
        print(string.format(
            "[CHECK] Server %d | ID: %s | Player: %d/%d",
            i,
            server.id,
            server.playing,
            server.maxPlayers
        ))

        if server.id == currentJobId then
            print("  -> SKIP: server sama")
            continue
        end

        if server.playing < MIN_PLAYER then
            print("  -> SKIP: terlalu sepi")
            continue
        end

        if server.playing > MAX_PLAYER then
            print("  -> SKIP: terlalu rame")
            continue
        end

        if server.playing >= (server.maxPlayers - 2) then
            print("  -> SKIP: hampir penuh")
            continue
        end

        print("  -> SERVER COCOK! mencoba teleport...")

        found = true
        TeleportService:TeleportToPlaceInstance(placeId, server.id)

        wait(2) 
        break
    end

    if not found then
        warn("[INFO] Tidak ada server cocok, retry...")
    end

    wait(3)
end
