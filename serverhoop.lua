local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local placeId = game.PlaceId
local currentJobId = game.JobId

local MIN_PLAYER = 19
local MAX_PLAYER = 19

local cursor = "" -- 🔥 simpan cursor halaman

print("=== SERVER HOP DEBUG + CURSOR START ===")
print("PlaceId:", placeId)
print("Current JobId:", currentJobId)

while true do
    print("\n[STEP] Ambil server list... Cursor:", cursor ~= "" and cursor or "FIRST PAGE")

    local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?sortOrder=Desc&limit=100"
    
    if cursor ~= "" then
        url = url .. "&cursor=" .. cursor
    end

    local success, result = pcall(function()
        return game:HttpGet(url)
    end)

    if not success then
        warn("[ERROR] Gagal ambil server list!")
        wait(5)
        continue
    end

    local data = HttpService:JSONDecode(result)

    if not data or not data.data then
        warn("[ERROR] Data server kosong / invalid")
        wait(5)
        continue
    end

    print("[INFO] Total server halaman ini:", #data.data)

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

        if server.playing >= (server.maxPlayers - 0) then
            print("  -> SKIP: hampir penuh")
            continue
        end

        print("  -> ✅ SERVER COCOK! mencoba teleport...")

        found = true
        TeleportService:TeleportToPlaceInstance(placeId, server.id)

        wait(2)
        break
    end

    -- 🔥 kalau tidak ketemu, pindah halaman
    if not found then
        if data.nextPageCursor then
            cursor = data.nextPageCursor
            warn("[INFO] Tidak ada server cocok, pindah ke halaman berikutnya...")
        else
            warn("[INFO] Sudah halaman terakhir, reset ke awal...")
            cursor = "" -- balik ke page 1 lagi
        end
    end

    wait(5)
end
