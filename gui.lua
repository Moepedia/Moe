-- Moe V1.0 GUI for FISH IT - FINAL WORKING VERSION
-- Dengan path remote yang benar dari folder Packages

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
local TeleportLocations = {
    "Spawn",
    "Sisyphus Statue",
    "Coral Reefs",
    "Esoteric Depths",
    "Crater Island",
    "Lost Isle",
    "Weather Machine",
    "Tropical Grove",
    "Mount Hallow",
    "Treasure Room",
    "Kohana",
    "Underground Cellar",
    "Ancient Jungle",
    "Sacred Temple"
}

-- ===== DATA BAIT (HARGA SAJA) =====
local BaitData = {
    {name = "Starter Bait", price = "Free"},
    {name = "Topwater Bait", price = "100$"},
    {name = "Luck Bait", price = "1,000$"},
    {name = "Midnight Bait", price = "3,000$"},
    {name = "Nature Bait", price = "83,500$"},
    {name = "Chroma Bait", price = "290,000$"},
    {name = "Royal Bait", price = "425,000$"},
    {name = "Dark Matter Bait", price = "630,000$"},
    {name = "Corrupt Bait", price = "1,150,000$"},
    {name = "Aether Bait", price = "3,700,000$"},
    {name = "Floral Bait", price = "4,000,000$"},
    {name = "Singularity Bait", price = "8,200,000$"}
}

-- ===== DATA ROD (HARGA SAJA) =====
local RodData = {
    {name = "Starter Rod", price = "0$"},
    {name = "Luck Rod", price = "250$"},
    {name = "Carbon Rod", price = "900$"},
    {name = "Toy Rod", price = "0$"},
    {name = "Grass Rod", price = "1,500$"},
    {name = "Damascus Rod", price = "3,000$"},
    {name = "Ice Rod", price = "5,000$"},
    {name = "Lava Rod", price = "0$"},
    {name = "Lucky Rod", price = "10,000$"},
    {name = "Midnight Rod", price = "50,000$"},
    {name = "Steampunk Rod", price = "215,000$"},
    {name = "Chrome Rod", price = "437,000$"},
    {name = "Fluorescent Rod", price = "715,000$"},
    {name = "Astral Rod", price = "1,000,000$"},
    {name = "Hazmat Rod", price = "1,300,000$"},
    {name = "Ares Rod", price = "3,000,000$"},
    {name = "Angler Rod", price = "8,000,000$"},
    {name = "Ghostfinn Rod", price = "Quest"},
    {name = "Bamboo Rod", price = "12,000,000$"},
    {name = "Element Rod", price = "Quest"},
    {name = "Diamond Rod", price = "Quest"}
}

-- ===== DATA WEATHER (HARGA SAJA) =====
local WeatherData = {
    {name = "Wind", price = "10,000"},
    {name = "Cloudy", price = "20,000"},
    {name = "Snow", price = "15,000"},
    {name = "Storm", price = "35,000"},
    {name = "Radiant", price = "50,000"},
    {name = "Shark Hunt", price = "300,000"}
}

-- ===== DATA EVENT =====
local EventData = {
    {name = "Shark Hunt", location = "Ocean", reward = "Shark"},
    {name = "Christmas 2025", location = "Event Island", reward = "Skins"}
}

-- ===== DATA QUEST =====
local QuestData = {
    {
        name = "Ghostfinn Rod",
        requirements = {
            "Catch 300 Rare/Epic fish in Treasure Room",
            "Catch 3 Mythic at Sisyphus Statue",
            "Catch 1 Secret at Sisyphus Statue",
            "Earn 1M coins"
        },
        locations = {"Treasure Room", "Sisyphus Statue"}
    },
    {
        name = "Element Rod",
        requirements = {
            "Own Ghostfinn Rod",
            "Catch 1 Secret at Ancient Jungle",
            "Catch 1 Secret at Sacred Temple",
            "Create 3 Transcended Stones"
        },
        locations = {"Ancient Jungle", "Sacred Temple"}
    },
    {
        name = "Diamond Rod",
        requirements = {
            "Own Element Rod",
            "Catch SECRET Fish at Coral Reefs",
            "Catch SECRET Fish at Tropical Grove",
            "Bring Lary a Mutated Gemstone Ruby",
            "Bring Lary a Lochness Monster",
            "Catch 1000 Fish while using PERFECT throw"
        },
        locations = {"Coral Reefs", "Tropical Grove"}
    }
}

-- ===== REMOTE FUNCTIONS DARI PACKAGES =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemoteFromPackages(folder, name)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    if folder == "RF" then
        local rf = packages:FindFirstChild("RF")
        if rf then
            return rf:FindFirstChild(name)
        end
    elseif folder == "RE" then
        local re = packages:FindFirstChild("RE")
        if re then
            return re:FindFirstChild(name)
        end
    end
    
    return nil
end

local Remote = {
    -- Fishing
    ChargeRod = getRemoteFromPackages("RF", "ChargeFishingRod"),
    CatchFish = getRemoteFromPackages("RF", "CatchFishCompleted"),
    FishingMinigame = getRemoteFromPackages("RE", "FishingMinigameChanged"),
    FishingStopped = getRemoteFromPackages("RE", "FishingStopped"),
    
    -- Bait
    PurchaseBait = getRemoteFromPackages("RF", "PurchaseBait"),
    EquipBait = getRemoteFromPackages("RE", "EquipBait"),
    
    -- Rod
    PurchaseRod = getRemoteFromPackages("RF", "PurchaseFishingRod"),
    EquipRodSkin = getRemoteFromPackages("RE", "EquipRodSkin"),
    
    -- Weather
    PurchaseWeather = getRemoteFromPackages("RF", "PurchaseWeatherEvent"),
    WeatherCommand = getRemoteFromPackages("RE", "WeatherCommand"),
    
    -- Teleport
    SubmarineTP = getRemoteFromPackages("RE", "SubmarineTP"),
    SubmarineTP2 = getRemoteFromPackages("RF", "SubmarineTP2"),
    BoatTeleport = getRemoteFromPackages("RE", "BoatTeleport"),
    
    -- Quest
    ClaimDailyLogin = getRemoteFromPackages("RF", "ClaimDailyLogin"),
    ClaimBounty = getRemoteFromPackages("RF", "ClaimBounty"),
    ClaimEventReward = getRemoteFromPackages("RE", "ClaimEventReward"),
    ClaimMegalodon = getRemoteFromPackages("RF", "RF_ClaimMegalodonQuest"),
    CreateStone = getRemoteFromPackages("RF", "CreateTranscendedStone"),
    
    -- Sell
    SellAll = getRemoteFromPackages("RF", "SellAllItems"),
    SellItem = getRemoteFromPackages("RF", "SellItem"),
    
    -- Favorite
    Favorite = getRemoteFromPackages("RE", "FavoriteItem"),
    FavoriteState = getRemoteFromPackages("RE", "FavoriteStateChanged")
}

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 650, 0, 400)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Border
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.3
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Size = UDim2.new(1, 0, 0, 35)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

-- Logo
local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(0, 25, 0, 25)
logo.Position = UDim2.new(0, 8, 0.5, -12.5)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = headerFrame

-- Title
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

-- Close button
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

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- ===== MENU BAR =====
local menuBar = Instance.new("Frame")
menuBar.Size = UDim2.new(1, 0, 0, 30)
menuBar.Position = UDim2.new(0, 0, 0, 35)
menuBar.BackgroundTransparency = 1
menuBar.Parent = mainFrame

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Horizontal
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.VerticalAlignment = Enum.VerticalAlignment.Center
menuLayout.Padding = UDim.new(0, 5)
menuLayout.Parent = menuBar

-- ===== CONTENT AREA =====
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -85)
contentFrame.Position = UDim2.new(0, 10, 0, 70)
contentFrame.BackgroundTransparency = 1
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentList = Instance.new("UIListLayout")
contentList.FillDirection = Enum.FillDirection.Vertical
contentList.HorizontalAlignment = Enum.HorizontalAlignment.Left
contentList.VerticalAlignment = Enum.VerticalAlignment.Top
contentList.Padding = UDim.new(0, 8)
contentList.Parent = contentFrame

-- ===== FUNGSI MEMBUAT DROPDOWN =====
local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = default or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -20, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    arrow.TextSize = 12
    arrow.Parent = frame
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, #options * 30)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 35)
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.BackgroundTransparency = 0.1
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdownFrame
    
    local dropdownList = Instance.new("UIListLayout")
    dropdownList.FillDirection = Enum.FillDirection.Vertical
    dropdownList.Padding = UDim.new(0, 2)
    dropdownList.Parent = dropdownFrame
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextSize = 14
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

-- ===== FUNGSI MEMBUAT BUTTON =====
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

-- ===== FUNGSI MEMBUAT LABEL =====
local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
end

-- ===== FUNGSI MEMBUAT INFO BOX =====
local function createInfoBox(parent, title, content)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, -10, 0, 60)
    frame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
    frame.BackgroundTransparency = 0.2
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 5, 0, 3)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 0)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -10, 0, 30)
    contentLabel.Position = UDim2.new(0, 5, 0, 23)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    contentLabel.TextSize = 12
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = frame
end

-- ===== FUNGSI CLEAR CONTENT =====
local function clearContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====

-- Fishing Menu
local function showFishing()
    clearContent()
    
    createLabel(contentFrame, "⚡ Instant Fishing")
    createButton(contentFrame, "CHARGE ROD", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:FireServer()
            notify("Fishing", "Rod charged")
        end
    end)
    
    createButton(contentFrame, "CATCH FISH", function()
        if Remote.CatchFish then
            Remote.CatchFish:FireServer()
            notify("Fishing", "Fish caught")
        end
    end)
    
    createLabel(contentFrame, "⚡ Blatant Mode")
    createButton(contentFrame, "BYPASS MINIGAME", function()
        if Remote.FishingMinigame then
            Remote.FishingMinigame:FireServer(true)
            notify("Fishing", "Minigame bypassed")
        end
    end)
    
    createLabel(contentFrame, "💰 Auto Sell")
    createButton(contentFrame, "SELL ALL NOW", function()
        if Remote.SellAll then
            Remote.SellAll:FireServer()
            notify("Fishing", "All items sold")
        end
    end)
end

-- Bait Menu
local function showBait()
    clearContent()
    
    createLabel(contentFrame, "🎣 Select Bait")
    
    local baitNames = {}
    for _, bait in ipairs(BaitData) do
        table.insert(baitNames, bait.name .. " (" .. bait.price .. ")")
    end
    
    local selectedBait = "Starter Bait"
    
    createDropdown(contentFrame, baitNames, baitNames[1], function(selected)
        selectedBait = selected:match("([^(]+)"):gsub("%s+$", "")
        notify("Bait", "Selected: " .. selectedBait)
    end)
    
    createButton(contentFrame, "BUY SELECTED BAIT", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer(selectedBait, 1)
            notify("Bait", "Purchased " .. selectedBait)
        end
    end)
    
    createButton(contentFrame, "EQUIP SELECTED BAIT", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer(selectedBait)
            notify("Bait", "Equipped " .. selectedBait)
        end
    end)
end

-- Rod Menu
local function showRod()
    clearContent()
    
    createLabel(contentFrame, "🎣 Select Rod")
    
    local rodNames = {}
    for _, rod in ipairs(RodData) do
        table.insert(rodNames, rod.name .. " (" .. rod.price .. ")")
    end
    
    local selectedRod = "Starter Rod"
    
    createDropdown(contentFrame, rodNames, rodNames[1], function(selected)
        selectedRod = selected:match("([^(]+)"):gsub("%s+$", "")
        notify("Rod", "Selected: " .. selectedRod)
    end)
    
    createButton(contentFrame, "BUY SELECTED ROD", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer(selectedRod, 1)
            notify("Rod", "Purchased " .. selectedRod)
        end
    end)
    
    createButton(contentFrame, "EQUIP ROD SKIN", function()
        if Remote.EquipRodSkin then
            Remote.EquipRodSkin:FireServer(selectedRod)
            notify("Rod", "Skin equipped")
        end
    end)
end

-- Weather Menu
local function showWeather()
    clearContent()
    
    createLabel(contentFrame, "☁️ Select Weather")
    
    local weatherNames = {}
    for _, w in ipairs(WeatherData) do
        table.insert(weatherNames, w.name .. " (" .. w.price .. " coins)")
    end
    
    local selectedWeather = "Clear"
    
    createDropdown(contentFrame, weatherNames, weatherNames[1], function(selected)
        selectedWeather = selected:match("([^(]+)"):gsub("%s+$", "")
        notify("Weather", "Selected: " .. selectedWeather)
    end)
    
    createButton(contentFrame, "ACTIVATE WEATHER", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer(selectedWeather)
            notify("Weather", "Activated " .. selectedWeather)
        end
    end)
    
    createLabel(contentFrame, "📦 Weather Slots")
    createButton(contentFrame, "BUY SLOT 1", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(1, selectedWeather)
            notify("Weather", "Slot 1 set to " .. selectedWeather)
        end
    end)
    
    createButton(contentFrame, "BUY SLOT 2", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(2, selectedWeather)
            notify("Weather", "Slot 2 set to " .. selectedWeather)
        end
    end)
    
    createButton(contentFrame, "BUY SLOT 3", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(3, selectedWeather)
            notify("Weather", "Slot 3 set to " .. selectedWeather)
        end
    end)
end

-- Teleport Menu
local function showTeleport()
    clearContent()
    
    createLabel(contentFrame, "🌍 Teleport to Location")
    
    local selectedLoc = TeleportLocations[1]
    
    createDropdown(contentFrame, TeleportLocations, TeleportLocations[1], function(selected)
        selectedLoc = selected
    end)
    
    createButton(conten-- Menu tabs
local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(1, -20, 0, 35)
tabFrame.Position = UDim2.new(0, 10, 0, 45)
tabFrame.BackgroundTransparency = 1
tabFrame.Parent = mainFrame

local tabs = {"Fishing", "Bait", "Rod", "Weather", "Teleport", "Quest", "Sell"}
local activeTab = "Fishing"

-- Content area
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -100)
contentFrame.Position = UDim2.new(0, 10, 0, 85)
contentFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentFrame.BorderSizePixel = 0
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = contentFrame

-- ===== UI ELEMENTS =====
local function createButton(text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, 0, 0)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Parent = contentFrame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function createLabel(text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -10, 0, 30)
    label.Position = UDim2.new(0, 5, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = contentFrame
end

-- ===== CLEAR CONTENT =====
local function clearContent()
    for _, child in pairs(contentFrame:GetChildren()) do
        if child:IsA("TextButton") or child:IsA("TextLabel") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====
local function showFishing()
    clearContent()
    createLabel("⚡ FISHING FEATURES")
    createButton("Charge Rod", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:FireServer()
            print("⚡ Rod charged")
        end
    end)
    createButton("Catch Fish", function()
        if Remote.CatchFish then
            Remote.CatchFish:FireServer()
            print("🎣 Fish caught")
        end
    end)
    createButton("Stop Fishing", function()
        if Remote.FishingStopped then
            Remote.FishingStopped:FireServer()
            print("⏹️ Fishing stopped")
        end
    end)
end

local function showBait()
    clearContent()
    createLabel("🎣 BAIT SHOP")
    createButton("Purchase Bait", function()
        if Remote.PurchaseBait then
            Remote.PurchaseBait:FireServer("Starter Bait", 1)
            print("✅ Bait purchased")
        end
    end)
    createButton("Equip Bait", function()
        if Remote.EquipBait then
            Remote.EquipBait:FireServer("Starter Bait")
            print("✅ Bait equipped")
        end
    end)
end

local function showRod()
    clearContent()
    createLabel("🎣 ROD SHOP")
    createButton("Purchase Rod", function()
        if Remote.PurchaseRod then
            Remote.PurchaseRod:FireServer("Starter Rod", 1)
            print("✅ Rod purchased")
        end
    end)
    createButton("Equip Rod Skin", function()
        if Remote.EquipRodSkin then
            Remote.EquipRodSkin:FireServer("Starter Rod")
            print("✅ Rod skin equipped")
        end
    end)
end

local function showWeather()
    clearContent()
    createLabel("☁️ WEATHER")
    createButton("Set Weather: Clear", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Clear")
            print("☀️ Weather set to Clear")
        end
    end)
    createButton("Set Weather: Rain", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Rain")
            print("🌧️ Weather set to Rain")
        end
    end)
    createButton("Set Weather: Storm", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Storm")
            print("⛈️ Weather set to Storm")
        end
    end)
    createButton("Purchase Weather Event", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(1, "Clear")
            print("✅ Weather event purchased")
        end
    end)
end

local function showTeleport()
    clearContent()
    createLabel("🌍 TELEPORT")
    createButton("Submarine TP", function()
        if Remote.SubmarineTP then
            Remote.SubmarineTP:FireServer("Spawn")
            print("🚀 Teleported")
        end
    end)
    createButton("Submarine TP2", function()
        if Remote.SubmarineTP2 then
            Remote.SubmarineTP2:InvokeServer("Spawn")
            print("🚀 Teleported")
        end
    end)
    createButton("Boat Teleport", function()
        if Remote.BoatTeleport then
            Remote.BoatTeleport:FireServer("Spawn")
            print("🚤 Boat teleported")
        end
    end)
end

local function showQuest()
    clearContent()
    createLabel("📋 QUESTS")
    createButton("Claim Daily Login", function()
        if Remote.ClaimDaily then
            Remote.ClaimDaily:FireServer()
            print("✅ Daily login claimed")
        end
    end)
    createButton("Claim Bounty", function()
        if Remote.ClaimBounty then
            Remote.ClaimBounty:FireServer()
            print("✅ Bounty claimed")
        end
    end)
    createButton("Claim Event Reward", function()
        if Remote.ClaimEvent then
            Remote.ClaimEvent:FireServer()
            print("✅ Event reward claimed")
        end
    end)
    createButton("Claim Megalodon Quest", function()
        if Remote.ClaimMegalodon then
            Remote.ClaimMegalodon:FireServer()
            print("✅ Megalodon quest claimed")
        end
    end)
end

local function showSell()
    clearContent()
    createLabel("💰 SELL")
    createButton("Sell All Items", function()
        if Remote.SellAll then
            Remote.SellAll:FireServer()
            print("✅ All items sold")
        end
    end)
    createButton("Sell Item", function()
        if Remote.SellItem then
            Remote.SellItem:FireServer(1)
            print("✅ Item sold")
        end
    end)
end

-- ===== CREATE TABS =====
local function createTab(name, xPos)
    local tab = Instance.new("TextButton")
    tab.Size = UDim2.new(0, 70, 0, 30)
    tab.Position = UDim2.new(0, xPos, 0, 2)
    tab.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    tab.Text = name
    tab.TextColor3 = Color3.new(1, 1, 1)
    tab.Font = Enum.Font.Gotham
    tab.TextSize = 13
    tab.Parent = tabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 4)
    tabCorner.Parent = tab
    
    if name == activeTab then
        tab.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
    end
    
    tab.MouseButton1Click:Connect(function()
        -- Reset all tabs
        for _, child in pairs(tabFrame:GetChildren()) do
            if child:IsA("TextButton") then
                child.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
            end
        end
        tab.BackgroundColor3 = Color3.new(0.3, 0.6, 0.3)
        
        -- Show selected menu
        if name == "Fishing" then showFishing()
        elseif name == "Bait" then showBait()
        elseif name == "Rod" then showRod()
        elseif name == "Weather" then showWeather()
        elseif name == "Teleport" then showTeleport()
        elseif name == "Quest" then showQuest()
        elseif name == "Sell" then showSell()
        end
    end)
end

-- Create tabs
for i, name in ipairs(tabs) do
    createTab(name, 5 + (i-1) * 75)
end

-- Show default tab
showFishing()

print("✅ Moe V1.0 GUI Loaded - Semua remote dari folder Packages")
