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

local player = game.Players.LocalPlayer

--// GUI ROOT
local gui = Instance.new("ScreenGui")
gui.Name = "FishUI"
gui.Parent = player.PlayerGui

-- MAIN FRAME
local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 450)
main.Position = UDim2.new(0.5, -200, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Fish System"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.TextScaled = true

-- TAB HOLDER
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,0,0,35)
tabBar.Position = UDim2.new(0,0,0,40)
tabBar.BackgroundTransparency = 1

local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal

-- CONTENT HOLDER
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-75)
content.Position = UDim2.new(0,0,0,75)
content.BackgroundTransparency = 1

-- CREATE TAB FUNCTION
local tabs = {}
local function createTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0.5,0,1,0)
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.TextColor3 = Color3.new(1,1,1)

    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.CanvasSize = UDim2.new(0,0,0,0)
    frame.Visible = false
    frame.BackgroundTransparency = 1
    frame.ScrollBarThickness = 6

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,5)

    tabs[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabs) do
            f.Visible = false
        end
        frame.Visible = true
    end)

    return frame
end

-- CREATE TABS
local eventTab = createTab("Events")
local serverTab = createTab("Server Hop")

tabs["Events"].Visible = true

--// =========================
--// 🎛️ TOGGLE UI FUNCTION
--// =========================

local function createToggle(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,30)
    btn.TextColor3 = Color3.new(1,1,1)

    local state = default

    local function update()
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    end

    update()

    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
        callback(state)
    end)

    return btn
end

--// =========================
--// 📜 EVENT LIST (DINAMIS)
--// =========================

local eventsFolder = player.PlayerGui:WaitForChild("Events")
    :WaitForChild("Frame")
    :WaitForChild("Events")

local eventButtons = {}

local function refreshEvents()
    for _, v in pairs(eventTab:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    for _, event in pairs(eventsFolder:GetChildren()) do
        local btn = createToggle(eventTab, event.Name, Settings.SelectedEvents[event.Name], function(state)
            Settings.SelectedEvents[event.Name] = state
            saveSettings()
        end)

        eventButtons[event.Name] = btn
    end

    task.wait()
    eventTab.CanvasSize = UDim2.new(0,0,0,#eventsFolder:GetChildren()*35)
end

refreshEvents()

-- auto update jika event berubah
eventsFolder.ChildAdded:Connect(refreshEvents)
eventsFolder.ChildRemoved:Connect(refreshEvents)

--// =========================
--// 🌐 WEBHOOK INPUT
--// =========================

local webhookBox = Instance.new("TextBox", eventTab)
webhookBox.PlaceholderText = "Webhook URL"
webhookBox.Text = Settings.WebhookURL
webhookBox.Size = UDim2.new(1,0,0,30)

webhookBox.FocusLost:Connect(function()
    Settings.WebhookURL = webhookBox.Text
    saveSettings()
end)

--// =========================
--// 🔄 SERVER TAB
--// =========================

local function createInput(parent, text, value, callback)
    local box = Instance.new("TextBox", parent)
    box.Size = UDim2.new(1,0,0,30)
    box.Text = tostring(value)
    box.PlaceholderText = text

    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then
            callback(num)
            saveSettings()
        end
    end)
end

createInput(serverTab, "Hop Delay", Settings.HopDelay, function(v)
    Settings.HopDelay = v
end)

createInput(serverTab, "Min Players", Settings.MinPlayers, function(v)
    Settings.MinPlayers = v
end)

createInput(serverTab, "Max Players", Settings.MaxPlayers, function(v)
    Settings.MaxPlayers = v
end)

-- SORT TOGGLE
createToggle(serverTab, "Sort Desc", Settings.SortOrder == "Desc", function(state)
    Settings.SortOrder = state and "Desc" or "Asc"
    saveSettings()
end)

-- AUTO HOP
createToggle(serverTab, "Auto Hop If Not Found", Settings.AutoHopIfNotFound, function(state)
    Settings.AutoHopIfNotFound = state
    saveSettings()
end)

-- START BUTTON
local hopBtn = Instance.new("TextButton", serverTab)
hopBtn.Text = "START SERVER HOP"
hopBtn.Size = UDim2.new(1,0,0,40)
hopBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
hopBtn.TextColor3 = Color3.new(1,1,1)

hopBtn.MouseButton1Click:Connect(function()
    task.spawn(serverHop)
end)
