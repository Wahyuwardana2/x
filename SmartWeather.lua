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
    AutoHopIfNotFound = false,
    AutoFindOnJoin = false
}

local Settings = {}

local function saveSettings()
    writefile(CONFIG_FILE, HttpService:JSONEncode(Settings))
end

local function loadSettings()
    if isfile(CONFIG_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)

        if success then
            Settings = data
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

    for _, name in pairs(active) do
        if Settings.SelectedEvents[name] then
            return true
        end
    end

    return false
end

--// =========================
--// 📡 WEBHOOK
--// =========================

local function sendWebhook(msg)
    if Settings.WebhookURL == "" then return end

    pcall(function()
        request({
            Url = Settings.WebhookURL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode({content = msg})
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
    if cursor then url = url.."&cursor="..cursor end
    return HttpService:JSONDecode(game:HttpGet(url))
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
--// 🧠 SMART SYSTEM
--// =========================

task.spawn(function()
    task.wait(5)

    if Settings.AutoFindOnJoin then
        if not hasTargetEvent() then
            serverHop()
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(3)

        local active = getActiveEvents()
        local found = false

        for _, name in pairs(active) do
            if Settings.SelectedEvents[name] then
                found = true

                if not lastSent[name] or tick() - lastSent[name] > 30 then
                    lastSent[name] = tick()
                    sendWebhook("🔥 Found: "..name)
                end
            end
        end

        if Settings.AutoHopIfNotFound and not found then
            serverHop()
            break
        end
    end
end)

--// =========================
--// 🎨 GUI (MODERN)
--// =========================

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FishUI"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 400, 0, 450)
main.Position = UDim2.new(0.5,-200,0.5,-225)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,40)
title.Text = "Fish System"
title.TextScaled = true
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1,0,0,35)
tabBar.Position = UDim2.new(0,0,0,40)

local layout = Instance.new("UIListLayout", tabBar)
layout.FillDirection = Enum.FillDirection.Horizontal

local content = Instance.new("Frame", main)
content.Size = UDim2.new(1,0,1,-75)
content.Position = UDim2.new(0,0,0,75)

local tabs = {}

local function createTab(name)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0.5,0,1,0)
    btn.Text = name

    local frame = Instance.new("ScrollingFrame", content)
    frame.Size = UDim2.new(1,0,1,0)
    frame.Visible = false
    frame.ScrollBarThickness = 6

    local layout = Instance.new("UIListLayout", frame)
    layout.Padding = UDim.new(0,5)

    tabs[name] = frame

    btn.MouseButton1Click:Connect(function()
        for _, f in pairs(tabs) do f.Visible = false end
        frame.Visible = true
    end)

    return frame
end

local eventTab = createTab("Events")
local serverTab = createTab("Server")

eventTab.Visible = true

-- toggle
local function createToggle(parent, text, state, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1,0,0,30)

    local function update()
        btn.Text = text..": "..(state and "ON" or "OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    end

    update()

    btn.MouseButton1Click:Connect(function()
        state = not state
        update()
        callback(state)
    end)
end

-- events dynamic
local function refreshEvents()
    for _, v in pairs(eventTab:GetChildren()) do
        if v:IsA("TextButton") then v:Destroy() end
    end

    for _, event in pairs(eventsFolder:GetChildren()) do
        createToggle(eventTab, event.Name, Settings.SelectedEvents[event.Name], function(state)
            Settings.SelectedEvents[event.Name] = state
            saveSettings()
        end)
    end
end

refreshEvents()

-- webhook
local webhook = Instance.new("TextBox", eventTab)
webhook.Text = Settings.WebhookURL
webhook.PlaceholderText = "Webhook URL"
webhook.Size = UDim2.new(1,0,0,30)

webhook.FocusLost:Connect(function()
    Settings.WebhookURL = webhook.Text
    saveSettings()
end)

-- server settings
local function input(parent, txt, val, cb)
    local box = Instance.new("TextBox", parent)
    box.Text = tostring(val)
    box.PlaceholderText = txt
    box.Size = UDim2.new(1,0,0,30)

    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then cb(n) saveSettings() end
    end)
end

input(serverTab,"Delay",Settings.HopDelay,function(v)Settings.HopDelay=v end)
input(serverTab,"Min",Settings.MinPlayers,function(v)Settings.MinPlayers=v end)
input(serverTab,"Max",Settings.MaxPlayers,function(v)Settings.MaxPlayers=v end)

createToggle(serverTab,"Auto Hop",Settings.AutoHopIfNotFound,function(v)
    Settings.AutoHopIfNotFound=v saveSettings()
end)

createToggle(serverTab,"Auto Find",Settings.AutoFindOnJoin,function(v)
    Settings.AutoFindOnJoin=v saveSettings()
end)

createToggle(serverTab,"Sort Desc",Settings.SortOrder=="Desc",function(v)
    Settings.SortOrder = v and "Desc" or "Asc"
    saveSettings()
end)

local hop = Instance.new("TextButton", serverTab)
hop.Text = "START HOP"
hop.Size = UDim2.new(1,0,0,40)
hop.BackgroundColor3 = Color3.fromRGB(0,120,255)

hop.MouseButton1Click:Connect(function()
    task.spawn(serverHop)
end)
