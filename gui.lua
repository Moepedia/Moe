-- Moe V1.0 GUI for FISH IT - LEFT MENU STYLE (650x400)
-- Menu: Fishing, Favorite, Shop, Teleport, Weather
-- Input delay manual (ketik angka)

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = player:WaitForChild("PlayerGui")

-- ===== DATA LOKASI TELEPORT =====
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

-- ===== DATA BAIT & ROD =====
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

local WeatherNames = {"Wind", "Cloudy", "Snow", "Storm", "Radiant", "Shark Hunt"}

-- ===== REMOTE PATHS =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Net = ReplicatedStorage:FindFirstChild("Packages") and 
            ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net

local RE = Net and Net:FindFirstChild("RE")
local RF = Net and Net:FindFirstChild("RF")

local function GetRemote(type, name)
    local folder = type == "RE" and RE or RF
    if folder then
        for _, remote in pairs(folder:GetChildren()) do
            if (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) and 
               string.find(remote.Name:lower(), name:lower()) then
                return remote
            end
        end
    end
    return nil
end

local Remote = {
    -- Fishing
    ChargeRod = GetRemote("RF", "ChargeFishingRod"),
    CatchFish = GetRemote("RF", "CatchFishCompleted"),
    FishingMinigame = GetRemote("RE", "FishingMinigameChanged"),
    FishingStopped = GetRemote("RE", "FishingStopped"),
    CaughtFishVisual = GetRemote("RE", "CaughtFishVisual"),
    
    -- Bait & Rod
    EquipBait = GetRemote("RE", "EquipBait"),
    EquipRodSkin = GetRemote("RE", "EquipRodSkin"),
    PurchaseBait = GetRemote("RF", "PurchaseBait"),
    PurchaseRod = GetRemote("RF", "PurchaseFishingRod"),
    
    -- Favorite
    FavoriteItem = GetRemote("RE", "FavoriteItem"),
    FavoriteStateChanged = GetRemote("RE", "FavoriteStateChanged"),
    
    -- Shop
    PurchaseWeather = GetRemote("RF", "PurchaseWeatherEvent"),
    PurchaseSkinCrate = GetRemote("RF", "PurchaseSkinCrate"),
    PurchaseEmoteCrate = GetRemote("RF", "PurchaseEmoteCrate"),
    
    -- Teleport
    SubmarineTP = GetRemote("RE", "SubmarineTP"),
    BoatTeleport = GetRemote("RE", "BoatTeleport"),
    TriggerSubmarine = GetRemote("RE", "TriggerSubmarine"),
    
    -- Weather
    WeatherCommand = GetRemote("RE", "WeatherCommand"),
    
    -- Sell
    SellAll = GetRemote("RF", "SellAllItems"),
    
    -- Daily
    ClaimDailyLogin = GetRemote("RF", "ClaimDailyLogin"),
}

-- ===== VARIABLES =====
local AutoFishing = false
local AutoEquipRod = false
local InstantFishing = false
local InstantFishingDelay = 0.5
local SelectedBait = BaitNames[1]
local SelectedRod = RodNames[1]
local SelectedWeather = WeatherNames[1]
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

-- ===== TELEPORT FUNCTION =====
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
        
        pcall(function()
            if Remote.SubmarineTP then
                Remote.SubmarineTP:FireServer(cf)
            end
        end)
    end
end

-- ===== INSTANT FISHING BYPASS =====
local function DoInstantFishing()
    if not InstantFishing then return end
    
    pcall(function()
        if Remote.CatchFish then
            Remote.CatchFish:FireServer()
            if Remote.CaughtFishVisual then
                Remote.CaughtFishVisual:FireServer()
            end
            if Remote.FishingStopped then
                Remote.FishingStopped:FireServer()
            end
        end
    end)
end

-- ===== AUTO FISHING LOOP =====
local function StartAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    
    FishingLoop = game:GetService("RunService").Heartbeat:Connect(function()
        if AutoFishing and InstantFishing then
            DoInstantFishing()
            task.wait(InstantFishingDelay)
        end
    end)
end

local function StopAutoFishing()
    if FishingLoop then
        FishingLoop:Disconnect()
        FishingLoop = nil
    end
    AutoFishing = false
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.2
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 100, 1, 0)
title.Position = UDim2.new(0, 38, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = headerFrame

local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 25, 0, 25)
minButton.Position = UDim2.new(1, -60, 0.5, -12.5)
minButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
minButton.BackgroundTransparency = 0.3
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextSize = 16
minButton.Font = Enum.Font.GothamBold
minButton.Parent = headerFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 4)
minCorner.Parent = minButton

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0.5, -12.5)
closeBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
closeBtn.BackgroundTransparency = 0.3
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 50, 0, 50)
floatingLogo.Position = UDim2.new(0.9, -25, 0.9, -25)
floatingLogo.BackgroundTransparency = 1
floatingLogo.Parent = gui
floatingLogo.Visible = false

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, 0, 1, 0)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo

minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
    StopAutoFishing()
    gui:Destroy()
end)

-- Horizontal line
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 35)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- ===== CONTENT CONTAINER =====
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -45)
contentContainer.Position = UDim2.new(0, 10, 0, 40)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- ===== LEFT MENU =====
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 120, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 6)
menuLayout.Parent = leftMenu

-- Vertical line
local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 130, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- ===== RIGHT CONTENT AREA =====
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -140, 1, 0)
contentArea.Position = UDim2.new(0, 140, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = contentContainer

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentArea

-- Content title
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

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -35)
scrollFrame.Position = UDim2.new(0, 5, 0, 30)
scrollFrame.BackgroundTransparency = 1
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 4
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENTS =====
local function createDropdown(options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
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
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdownFrame.Position = UDim2.new(0, 0, 1, 2)
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 13
        optBtn.Font = Enum.Font.Gotham
        optBtn.Parent = dropdownFrame
        optBtn.ZIndex = 11
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = opt
            dropdownFrame.Visible = false
            callback(opt)
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdownFrame.Visible = not dropdownFrame.Visible
    end)
    
    return frame
end

local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = featuresContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function createLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = featuresContainer
end

local function createToggle(text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
    
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
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 60, 0, 25)
    toggleBtn.Position = UDim2.new(1, -70, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = default and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    toggleBtn.Text = default and "ON" or "OFF"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.TextSize = 12
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleBtn
    
    local state = default
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.BackgroundColor3 = state and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
        toggleBtn.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function createInput(text, default, placeholder, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 50)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = featuresContainer
    
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
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 25)
    inputBox.Position = UDim2.new(0, 10, 0, 25)
    inputBox.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    inputBox.Text = tostring(default)
    inputBox.PlaceholderText = placeholder or "Enter value..."
    inputBox.TextColor3 = Color3.new(1, 1, 1)
    inputBox.PlaceholderColor3 = Color3.new(0.5, 0.5, 0.5)
    inputBox.TextSize = 13
    inputBox.Font = Enum.Font.Gotham
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = frame
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 4)
    inputCorner.Parent = inputBox
    
    inputBox.FocusLost:Connect(function()
        local value = tonumber(inputBox.Text) or default
        inputBox.Text = tostring(value)
        callback(value)
    end)
end

local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====
local function showFishing()
    clearFeatures()
    contentTitle.Text = "Fishing Features"
    
    createLabel("⚡ Instant Fishing")
    
    createToggle("Instant Fishing", InstantFishing, function(state)
        InstantFishing = state
        if not state then StopAutoFishing() end
        notify("Instant Fishing", state and "ON" or "OFF")
    end)
    
    createInput("Delay (seconds)", InstantFishingDelay, "0.1 - 2.0", function(value)
        InstantFishingDelay = math.clamp(value, 0.1, 2)
    end)
    
    createToggle("Auto Equip Rod", AutoEquipRod, function(state)
        AutoEquipRod = state
        notify("Auto Equip", state and "ON" or "OFF")
    end)
    
    createLabel("🎣 Auto Control")
    
    createButton("START AUTO FISHING", function()
        if InstantFishing then
            AutoFishing = true
            StartAutoFishing()
            notify("Auto Fishing", "Started")
        else
            notify("Error", "Enable Instant Fishing first!")
        end
    end)
    
    createButton("STOP AUTO FISHING", function()
        StopAutoFishing()
    end)
    
    createLabel("🔥 Manual Bypass")
    
    createButton("INSTANT CATCH", function()
        DoInstantFishing()
        notify("Bypass", "Fish caught!")
    end)
    
    createButton("CHARGE ROD", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:FireServer()
            notify("Rod", "Charged")
        end
    end)
    
    createButton("SELL ALL ITEMS", function()
        if Remote.SellAll then
            Remote.SellAll:FireServer()
            notify("Sell", "All items sold")
        end
    end)
end

local function showFavorite()
    clearFeatures()
    contentTitle.Text = "Favorite Items"
    
    createLabel("❤️ Favorite Management")
    
    createButton("FAVORITE CURRENT ITEM", function()
        if Remote.FavoriteItem then
            -- Ini perlu parameter item ID, coba tanpa parameter dulu
            pcall(function()
                Remote.FavoriteItem:FireServer()
            end)
            notify("Favorite", "Toggled favorite")
        end
    end)
    
    createButton("UNFAVORITE ALL", function()
        if Remote.FavoriteStateChanged then
            pcall(function()
                Remote.FavoriteStateChanged:FireServer(false)
            end)
            notify("Favorite", "All unfavorited")
        end
    end)
    
    createLabel("📦 Daily Rewards")
    
    createButton("CLAIM DAILY LOGIN", function()
        if Remote.ClaimDailyLogin then
            Remote.ClaimDailyLogin:FireServer()
            notify("Daily", "Claimed!")
        end
    end)
end

local function showShop()
    clearFeatures()
    contentTitle.Text = "Shop"
    
    createLabel("🛒 Bait Shop")
    
    createDropdown(BaitNames, SelectedBait, function(selected)
        SelectedBait = selected
    end)
    
    createButton("BUY SELECTED BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer(SelectedBait, 1)
            notify("Shop", "Bought " .. SelectedBait)
        end
    end)
    
    createButton("EQUIP SELECTED BAIT", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer(SelectedBait)
            notify("Shop", "Equipped " .. SelectedBait)
        end
    end)
    
    createLabel("🎣 Rod Shop")
    
    createDropdown(RodNames, SelectedRod, function(selected)
        SelectedRod = selected
    end)
    
    createButton("BUY SELECTED ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer(SelectedRod, 1)
            notify("Shop", "Bought " .. SelectedRod)
        end
    end)
    
    createButton("EQUIP ROD SKIN", function()
        if Remote.EquipRodSkin then
            Remote.EquipRodSkin:FireServer(SelectedRod)
            notify("Shop", "Equipped " .. SelectedRod)
        end
    end)
    
    createLabel("📦 Crates")
    
    createButton("BUY SKIN CRATE", function()
        if Remote.PurchaseSkinCrate then
            Remote.PurchaseSkinCrate:FireServer(1)
            notify("Shop", "Bought skin crate")
        end
    end)
    
    createButton("BUY EMOTE CRATE", function()
        if Remote.PurchaseEmoteCrate then
            Remote.PurchaseEmoteCrate:FireServer(1)
            notify("Shop", "Bought emote crate")
        end
    end)
end

local function showTeleport()
    clearFeatures()
    contentTitle.Text = "Teleport"
    
    createLabel("📍 Location Teleport")
    
    local locList = {}
    for loc, _ in pairs(LOCATIONS) do
        table.insert(locList, loc)
    end
    table.sort(locList)
    
    createDropdown(locList, SelectedLocation, function(selected)
        SelectedLocation = selected
    end)
    
    createButton("🚀 TELEPORT NOW", function()
        TeleportTo(SelectedLocation)
    end)
    
    createLabel("⚡ Quick Locations")
    local quickLocs = {"Spawn", "Treasure Room", "Ancient Jungle", "Coral Reefs", "Kohana"}
    for _, loc in ipairs(quickLocs) do
        if LOCATIONS[loc] then
            createButton("→ " .. loc, function()
                TeleportTo(loc)
            end)
        end
    end
    
    createLabel("👥 Player Teleport")
    
    local players = {}
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(players, p.Name)
        end
    end
    
    if #players > 0 then
        local selectedPlayer = players[1]
        
        createDropdown(players, selectedPlayer, function(selected)
            selectedPlayer = selected
        end)
        
        createButton("TELEPORT TO PLAYER", function()
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
                    notify("Teleport", "Teleported to " .. selectedPlayer)
                end
            end
        end)
    else
        createLabel("   No other players online")
    end
end

local function showWeather()
    clearFeatures()
    contentTitle.Text = "Weather Control"
    
    createLabel("🌦️ Select Weather")
    
    createDropdown(WeatherNames, SelectedWeather, function(selected)
        SelectedWeather = selected
    end)
    
    createButton("ACTIVATE WEATHER", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer(SelectedWeather)
            notify("Weather", SelectedWeather .. " activated")
        end
    end)
    
    createLabel("🎫 Weather Slots")
    
    createButton("BUY SLOT 1", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(1, SelectedWeather)
            notify("Weather", "Slot 1 set to " .. SelectedWeather)
        end
    end)
    
    createButton("BUY SLOT 2", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(2, SelectedWeather)
            notify("Weather", "Slot 2 set to " .. SelectedWeather)
        end
    end)
    
    createButton("BUY SLOT 3", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(3, SelectedWeather)
            notify("Weather", "Slot 3 set to " .. SelectedWeather)
        end
    end)
end

-- ===== LEFT MENU BUTTONS =====
local menuButtons = {
    {name = "Fishing", func = showFishing},
    {name = "Favorite", func = showFavorite},
    {name = "Shop", func = showShop},
    {name = "Teleport", func = showTeleport},
    {name = "Weather", func = showWeather}
}

local currentMenu = ""

for _, btnData in ipairs(menuButtons) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = btnData.name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = leftMenu
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.1
        end
    end)
    
    btn.MouseLeave:Connect(function()
        if currentMenu ~= btnData.name then
            btn.BackgroundTransparency = 0.3
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _, b in pairs(leftMenu:GetChildren()) do
            if b:IsA("TextButton") then
                b.BackgroundTransparency = 0.3
            end
        end
        btn.BackgroundTransparency = 0
        currentMenu = btnData.name
        btnData.func()
    end)
end

-- Show Fishing menu by default
task.wait(0.1)
showFishing()

-- ===== DRAG FUNCTIONALITY =====
local dragging = false
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("Moe V1.0 GUI Loaded - Menu: Fishing, Favorite, Shop, Teleport, Weather")