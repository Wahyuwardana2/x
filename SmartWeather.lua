--// SERVICES
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer

--// =========================
--// 💾 CONFIG SYSTEM
--// =========================

local CONFIG_FILE = "fish_config.json"

local defaultConfig = {
    WebhookURL = "",
    SelectedEvents = {},
    HopDelay = 10,
    MinPlayers = 1,
    MaxPlayers = 20,
    SortOrder = "Asc",
    AutoHopIfNotFound = false
}

local Settings = {}

local function saveSettings()
    writefile(CONFIG_FILE, HttpService:JSONEncode(Settings))
end

local function loadSettings()
    if isfile(CONFIG_FILE) then
        local data = readfile(CONFIG_FILE)
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)

        if success then
            Settings = decoded
        else
            Settings = defaultConfig
        end
    else
        Settings = defaultConfig
        writefile(CONFIG_FILE, HttpService:JSONEncode(Settings))
    end

    if type(Settings.SelectedEvents) ~= "table" then
        Settings.SelectedEvents = {}
    end

    if Settings.AutoHopIfNotFound == nil then
        Settings.AutoHopIfNotFound = false
    end
end

loadSettings()

--// =========================
--// 📂 EVENT SOURCE
--// =========================

local eventsFolder = player:WaitForChild("PlayerGui")
    :WaitForChild("Events")
    :WaitForChild("Frame")
    :WaitForChild("Events")

--// =========================
--// 🧠 EVENT DETECTION
--// =========================

local function isEventActive(event)
    if event:IsA("GuiObject") and event.Visible then
        return true
    end

    for _, v in pairs(event:GetDescendants()) do
        if v:IsA("TextLabel") and v.Text ~= "" then
            return true
        end
    end

    return false
end

local function getActiveEvents()
    local active = {}

    for _, event in pairs(eventsFolder:GetChildren()) do
        if isEventActive(event) then
            table.insert(active, event.Name)
        end
    end

    return active
end

local function hasTargetEvent()
    local active = getActiveEvents()

    for _, eventName in pairs(active) do
        if Settings.SelectedEvents[eventName] then
            return true
        end
    end

    return false
end

--// =========================
--// 📡 WEBHOOK
--// =========================

local function sendWebhook(message)
    if Settings.WebhookURL == "" then return end

    local data = {
        ["content"] = message
    }

    local json = HttpService:JSONEncode(data)

    pcall(function()
        request({
            Url = Settings.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = json
        })
    end)
end

local lastSent = {}

--// =========================
--// 🔄 SERVER HOP
--// =========================

local placeId = game.PlaceId
local hopping = false

local function getServers(cursor)
    local url = "https://games.roblox.com/v1/games/"..placeId.."/servers/Public?limit=100&sortOrder="..Settings.SortOrder
    if cursor then
        url = url .. "&cursor=" .. cursor
    end

    local res = game:HttpGet(url)
    return HttpService:JSONDecode(res)
end

local function serverHop()
    if hopping then return end
    hopping = true

    task.wait(Settings.HopDelay)

    local cursor = nil

    repeat
        local data = getServers(cursor)

        for _, server in pairs(data.data) do
            if server.playing >= Settings.MinPlayers 
            and server.playing <= Settings.MaxPlayers then
                
                TeleportService:TeleportToPlaceInstance(placeId, server.id)
                return
            end
        end

        cursor = data.nextPageCursor
    until not cursor
end

--// =========================
--// 🧠 SMART SYSTEM (AUTO STAY / HOP)
--// =========================

local function smartSystem()
    while true do
        task.wait(3)

        local active = getActiveEvents()
        local found = false

        for _, eventName in pairs(active) do
            if Settings.SelectedEvents[eventName] then
                found = true

                if not lastSent[eventName] or tick() - lastSent[eventName] > 30 then
                    lastSent[eventName] = tick()
                    sendWebhook("🔥 Event Found: " .. eventName)
                end
            end
        end

        if Settings.AutoHopIfNotFound then
            if not found then
                print("❌ Tidak ada event target, hop...")
                serverHop()
                break
            else
                print("✅ Event ditemukan, stay")
            end
        end
    end
end

task.spawn(smartSystem)

--// =========================
--// 🎨 GUI
--// =========================

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FishSystem"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 420)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

local layout = Instance.new("UIListLayout", frame)

local title = Instance.new("TextLabel", frame)
title.Text = "Fish System"
title.Size = UDim2.new(1,0,0,30)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1,1,1)

-- WEBHOOK
local webhookBox = Instance.new("TextBox", frame)
webhookBox.PlaceholderText = "Webhook URL"
webhookBox.Text = Settings.WebhookURL
webhookBox.Size = UDim2.new(1,0,0,30)

webhookBox.FocusLost:Connect(function()
    Settings.WebhookURL = webhookBox.Text
    saveSettings()
end)

-- EVENT LIST
for _, event in pairs(eventsFolder:GetChildren()) do
    local btn = Instance.new("TextButton", frame)
    btn.Text = event.Name
    btn.Size = UDim2.new(1,0,0,25)

    btn.BackgroundColor3 = Settings.SelectedEvents[event.Name] 
        and Color3.fromRGB(0,170,0) 
        or Color3.fromRGB(50,50,50)

    btn.MouseButton1Click:Connect(function()
        Settings.SelectedEvents[event.Name] = not Settings.SelectedEvents[event.Name]

        btn.BackgroundColor3 = Settings.SelectedEvents[event.Name] 
            and Color3.fromRGB(0,170,0) 
            or Color3.fromRGB(50,50,50)

        saveSettings()
    end)
end

-- AUTO HOP TOGGLE
local autoHopBtn = Instance.new("TextButton", frame)
autoHopBtn.Size = UDim2.new(1,0,0,30)

local function updateAutoHopText()
    autoHopBtn.Text = "Auto Hop If Not Found: " .. (Settings.AutoHopIfNotFound and "ON" or "OFF")
end

updateAutoHopText()

autoHopBtn.MouseButton1Click:Connect(function()
    Settings.AutoHopIfNotFound = not Settings.AutoHopIfNotFound
    updateAutoHopText()
    saveSettings()
end)

-- DELAY
local delayBox = Instance.new("TextBox", frame)
delayBox.Text = tostring(Settings.HopDelay)
delayBox.PlaceholderText = "Hop Delay"
delayBox.Size = UDim2.new(1,0,0,30)

delayBox.FocusLost:Connect(function()
    local num = tonumber(delayBox.Text)
    if num then
        Settings.HopDelay = num
        saveSettings()
    end
end)

-- MIN PLAYER
local minBox = Instance.new("TextBox", frame)
minBox.Text = tostring(Settings.MinPlayers)
minBox.PlaceholderText = "Min Players"
minBox.Size = UDim2.new(1,0,0,30)

minBox.FocusLost:Connect(function()
    local num = tonumber(minBox.Text)
    if num then
        Settings.MinPlayers = num
        saveSettings()
    end
end)

-- MAX PLAYER
local maxBox = Instance.new("TextBox", frame)
maxBox.Text = tostring(Settings.MaxPlayers)
maxBox.PlaceholderText = "Max Players"
maxBox.Size = UDim2.new(1,0,0,30)

maxBox.FocusLost:Connect(function()
    local num = tonumber(maxBox.Text)
    if num then
        Settings.MaxPlayers = num
        saveSettings()
    end
end)

-- SORT
local sortBtn = Instance.new("TextButton", frame)
sortBtn.Text = "Sort: " .. Settings.SortOrder
sortBtn.Size = UDim2.new(1,0,0,30)

sortBtn.MouseButton1Click:Connect(function()
    Settings.SortOrder = (Settings.SortOrder == "Asc") and "Desc" or "Asc"
    sortBtn.Text = "Sort: " .. Settings.SortOrder
    saveSettings()
end)

-- START HOP
local hopBtn = Instance.new("TextButton", frame)
hopBtn.Text = "START SERVER HOP"
hopBtn.Size = UDim2.new(1,0,0,40)

hopBtn.MouseButton1Click:Connect(function()
    task.spawn(serverHop)
end)
