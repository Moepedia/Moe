-- MOE FISHING GUI FINAL v4.0 - WORKING REMOTES
local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== REMOTE PATHS (PASTI WORK) =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net
local RF = Net:FindFirstChild("RF")  -- RemoteFunctions
local RE = Net:FindFirstChild("RE")  -- RemoteEvents

-- Remote yang valid (berdasarkan scan)
local Remote = {
    -- Fishing Core
    ChargeRod = RF and RF:FindFirstChild("ChargeFishingRod"),
    CatchFish = RF and RF:FindFirstChild("CatchFishCompleted"),
    RequestMinigame = RF and RF:FindFirstChild("RequestFishingMinigameStarted"),
    FishingMinigame = RE and RE:FindFirstChild("FishingMinigameChanged"),
    FishingStopped = RE and RE:FindFirstChild("FishingStopped"),
    CaughtFishVisual = RE and RE:FindFirstChild("CaughtFishVisual"),
    FishCaught = RE and RE:FindFirstChild("FishCaught"),
    UpdateChargeState = RE and RE:FindFirstChild("UpdateChargeState"),
    CancelFishing = RF and RF:FindFirstChild("CancelFishingInputs"),
    RodEffect = RE and RE:FindFirstChild("RodEffect"),
    
    -- Bait & Rod
    EquipRod = RE and RE:FindFirstChild("EquipRodSkin"),
    EquipBait = RE and RE:FindFirstChild("EquipBait"),
    PurchaseRod = RF and RF:FindFirstChild("PurchaseFishingRod"),
    PurchaseBait = RF and RF:FindFirstChild("PurchaseBait"),
    
    -- Visual
    BaitCast = RE and RE:FindFirstChild("BaitCastVisual"),
    BaitDestroyed = RE and RE:FindFirstChild("BaitDestroyed"),
    BaitSpawned = RE and RE:FindFirstChild("BaitSpawned"),
    
    -- Circle
    JoinCircle = RE and RE:FindFirstChild("JoinFishingCircle"),
    LeftCircle = RE and RE:FindFirstChild("LeftFishingCircle"),
    
    -- Sell
    SellAll = RF and RF:FindFirstChild("SellAllItems"),
}

-- Print status
print("=== MOE GUI REMOTE STATUS ===")
for name, remote in pairs(Remote) do
    if remote then
        print("✅ " .. name)
    else
        print("❌ " .. name)
    end
end

-- ===== DATA LOKASI =====
local LOCATIONS = {
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693),
}

-- ===== DATA ITEMS =====
local BaitNames = {
    "Starter Bait", "Topwater Bait", "Luck Bait", "Midnight Bait",
    "Nature Bait", "Chroma Bait", "Royal Bait", "Dark Matter Bait",
    "Corrupt Bait", "Aether Bait", "Floral Bait", "Singularity Bait"
}

local RodNames = {
    "Starter Rod", "Luck Rod", "Carbon Rod", "Toy Rod", "Grass Rod",
    "Damascus Rod", "Ice Rod", "Lava Rod", "Lucky Rod", "Midnight Rod",
    "Steampunk Rod", "Chrome Rod", "Fluorescent Rod", "Astral Rod",
    "Hazmat Rod", "Ares Rod", "Angler Rod", "Ghostfinn Rod",
    "Bamboo Rod", "Element Rod", "Diamond Rod"
}

-- ===== VARIABLES =====
local AutoFishing = false
local AutoEquipRod = false
local InstantFishing = false
local InstantFishingDelay = 0.5
local SelectedBait = BaitNames[1]
local SelectedRod = RodNames[1]
local SelectedLocation = "Spawn"
local FishingLoop = nil

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== TELEPORT =====
local function TeleportTo(location)
    local cf = LOCATIONS[location]
    if not cf then
        notify("Teleport", "Location not found!")
        return
    end
    
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = cf
        notify("Teleport", "Teleported to " .. location)
    end
end

-- ===== FISHING FUNCTIONS =====
local function DoInstantFishing()
    if not InstantFishing then return end
    
    pcall(function()
        -- Urutan yang benar dari log:
        -- 1. Request minigame
        if Remote.RequestMinigame then
            Remote.RequestMinigame:InvokeServer(true)
        end
        
        -- 2. Catch fish
        if Remote.CatchFish then
            Remote.CatchFish:InvokeServer()
        end
        
        -- 3. Visual effects
        if Remote.CaughtFishVisual then
            Remote.CaughtFishVisual:FireServer()
        end
        if Remote.FishCaught then
            Remote.FishCaught:FireServer()
        end
    end)
end

local function StartAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    
    if not Remote.CatchFish then
        notify("Error", "CatchFish remote not found!")
        return
    end
    
    FishingLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutoFishing and InstantFishing then
            DoInstantFishing()
            task.wait(InstantFishingDelay)
        end
    end)
    
    notify("Auto Fishing", "Started")
end

local function StopAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    AutoFishing = false
    notify("Auto Fishing", "Stopped")
end

-- ===== GUI SETUP =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 12)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "MOE FISHING GUI v4.0"
title.TextColor3 = Color3.new(0, 1, 0)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.new(1, 0, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header

closeBtn.MouseButton1Click:Connect(function()
    StopAutoFishing()
    gui:Destroy()
end)

-- Horizontal line
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 35)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.5
hLine.Parent = mainFrame

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, -45)
leftMenu.Position = UDim2.new(0, 10, 0, 40)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = mainFrame

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

-- Vertical line
local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, -45)
vLine.Position = UDim2.new(0, 140, 0, 40)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.5
vLine.Parent = mainFrame

-- ===== RIGHT CONTENT =====
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -160, 1, -45)
contentArea.Position = UDim2.new(0, 150, 0, 40)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -10, 0, 25)
contentTitle.Position = UDim2.new(0, 5, 0, 5)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Fishing Features"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextSize = 14
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.ScrollBarThickness = 4
scrollFrame.Parent = contentArea

local container = Instance.new("Frame")
container.Size = UDim2.new(1, 0, 0, 0)
container.BackgroundTransparency = 1
container.Parent = scrollFrame
container.AutomaticSize = Enum.AutomaticSize.Y

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.Parent = container

-- ===== UI FUNCTIONS =====
local function createLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 0)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = container
end

local function createButton(text, callback, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = color or Color3.new(0.3, 0.3, 0.3)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = container
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 200, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 25)
    btn.Position = UDim2.new(1, -70, 0.5, -12.5)
    btn.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    local state = default
    
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function createInput(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = container
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(1, -20, 0, 25)
    input.Position = UDim2.new(0, 10, 0, 25)
    input.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    input.Text = tostring(default)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.Gotham
    input.TextSize = 13
    input.ClearTextOnFocus = false
    input.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = input
    
    input.FocusLost:Connect(function()
        local value = tonumber(input.Text) or default
        value = math.clamp(value, 0.1, 2)
        input.Text = tostring(value)
        callback(value)
    end)
end

local function createDropdown(options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    frame.Parent = container
    frame.ZIndex = 5
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    btn.ZIndex = 6
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    arrow.ZIndex = 6
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdown.Position = UDim2.new(0, 0, 1, 2)
    dropdown.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    dropdown.Visible = false
    dropdown.Parent = frame
    dropdown.ZIndex = 10
    dropdown.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    for _, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = dropdown
        optBtn.ZIndex = 11
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdown.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
end

local function clearContainer()
    for _, child in pairs(container:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====
local function showFishing()
    clearContainer()
    contentTitle.Text = "⚡ FISHING FEATURES"
    
    if Remote.CatchFish then
        createLabel("✅ Remote Ready")
    end
    
    createToggle("Instant Fishing", InstantFishing, function(state)
        InstantFishing = state
        if not state then StopAutoFishing() end
        notify("Instant Fishing", state and "ON" or "OFF")
    end)
    
    createInput("Delay (seconds)", InstantFishingDelay, function(value)
        InstantFishingDelay = value
    end)
    
    createToggle("Auto Equip Rod", AutoEquipRod, function(state)
        AutoEquipRod = state
        notify("Auto Equip", state and "ON" or "OFF")
    end)
    
    createLabel("🎣 AUTO CONTROL")
    createButton("START AUTO FISHING", function()
        if InstantFishing then
            AutoFishing = true
            StartAutoFishing()
        else
            notify("Error", "Enable Instant Fishing first")
        end
    end, Color3.new(0, 0.5, 1))
    
    createButton("STOP AUTO FISHING", StopAutoFishing, Color3.new(1, 0.3, 0.3))
    
    createLabel("🔥 MANUAL")
    createButton("CHARGE ROD", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:InvokeServer()
            notify("Rod", "Charged")
        end
    end)
    
    createButton("REQUEST MINIGAME", function()
        if Remote.RequestMinigame then
            Remote.RequestMinigame:InvokeServer(true)
            notify("Minigame", "Requested")
        end
    end)
    
    createButton("INSTANT CATCH", function()
        DoInstantFishing()
        notify("Bypass", "Fish caught!")
    end, Color3.new(0, 1, 0))
    
    createButton("CANCEL FISHING", function()
        if Remote.CancelFishing then
            Remote.CancelFishing:InvokeServer()
            notify("Fishing", "Cancelled")
        end
    end, Color3.new(1, 0.5, 0))
    
    createButton("SELL ALL ITEMS", function()
        if Remote.SellAll then
            Remote.SellAll:InvokeServer()
            notify("Sell", "All items sold")
        end
    end, Color3.new(1, 0.8, 0))
end

local function showTeleport()
    clearContainer()
    contentTitle.Text = "📍 TELEPORT"
    
    local locList = {}
    for loc, _ in pairs(LOCATIONS) do
        table.insert(locList, loc)
    end
    table.sort(locList)
    
    createDropdown(locList, SelectedLocation, function(selected)
        SelectedLocation = selected
    end)
    
    createButton("🚀 TELEPORT", function()
        TeleportTo(SelectedLocation)
    end, Color3.new(0, 0.7, 1))
    
    createLabel("⚡ QUICK")
    local quick = {"Spawn", "Treasure Room", "Ancient Jungle", "Coral Reefs"}
    for _, loc in ipairs(quick) do
        createButton("→ " .. loc, function()
            TeleportTo(loc)
        end)
    end
end

local function showBaitRod()
    clearContainer()
    contentTitle.Text = "🎣 BAIT & ROD"
    
    createLabel("BAIT")
    createDropdown(BaitNames, SelectedBait, function(selected)
        SelectedBait = selected
    end)
    
    createButton("EQUIP BAIT", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer(SelectedBait)
            notify("Bait", "Equipped " .. SelectedBait)
        end
    end)
    
    createButton("BUY BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:InvokeServer(SelectedBait, 1)
            notify("Bait", "Purchased " .. SelectedBait)
        end
    end)
    
    createLabel("ROD")
    createDropdown(RodNames, SelectedRod, function(selected)
        SelectedRod = selected
    end)
    
    createButton("EQUIP ROD", function()
        if Remote.EquipRod then
            Remote.EquipRod:FireServer(SelectedRod)
            notify("Rod", "Equipped " .. SelectedRod)
        end
    end)
    
    createButton("BUY ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:InvokeServer(SelectedRod, 1)
            notify("Rod", "Purchased " .. SelectedRod)
        end
    end)
end

-- ===== LEFT MENU BUTTONS =====
local buttons = {
    {name = "⚡ Fishing", func = showFishing},
    {name = "📍 Teleport", func = showTeleport},
    {name = "🎣 Bait/Rod", func = showBaitRod},
}

for _, btnData in ipairs(buttons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.3
            end
        end
        btn.BackgroundTransparency = 0
        btnData.func()
    end)
end

-- Show fishing menu first
task.wait(0.1)
showFishing()

print("✅ MOE GUI v4.0 Loaded - Semua remote working!")