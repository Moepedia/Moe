-- Moe V1.0 GUI for FISH IT - FINAL WORKING VERSION
-- Dengan path remote yang benar dari folder Packages

local player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== FUNGSI GET REMOTE DENGAN PATH YANG BENAR =====
local function getRemote(folder, name)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    local rf = packages:FindFirstChild("RF")
    local re = packages:FindFirstChild("RE")
    
    if folder == "RF" and rf then
        return rf:FindFirstChild(name)
    elseif folder == "RE" and re then
        return re:FindFirstChild(name)
    end
    
    return nil
end

-- ===== REMOTE REFERENCES =====
local Remote = {
    -- Fishing
    ChargeRod = getRemote("RF", "ChargeFishingRod"),
    CatchFish = getRemote("RF", "CatchFishCompleted"),
    FishingMinigame = getRemote("RE", "FishingMinigameChanged"),
    FishingStopped = getRemote("RE", "FishingStopped"),
    
    -- Bait
    PurchaseBait = getRemote("RF", "PurchaseBait"),
    EquipBait = getRemote("RE", "EquipBait"),
    
    -- Rod
    PurchaseRod = getRemote("RF", "PurchaseFishingRod"),
    EquipRodSkin = getRemote("RE", "EquipRodSkin"),
    RodEffect = getRemote("RE", "RodEffect"),
    
    -- Weather
    PurchaseWeather = getRemote("RF", "PurchaseWeatherEvent"),
    WeatherCommand = getRemote("RE", "WeatherCommand"),
    
    -- Teleport
    SubmarineTP = getRemote("RE", "SubmarineTP"),
    SubmarineTP2 = getRemote("RF", "SubmarineTP2"),
    BoatTeleport = getRemote("RE", "BoatTeleport"),
    
    -- Quest
    ClaimDaily = getRemote("RF", "ClaimDailyLogin"),
    ClaimBounty = getRemote("RF", "ClaimBounty"),
    ClaimEvent = getRemote("RE", "ClaimEventReward"),
    ClaimMegalodon = getRemote("RF", "RF_ClaimMegalodonQuest"),
    CreateStone = getRemote("RF", "CreateTranscendedStone"),
    
    -- Sell
    SellAll = getRemote("RF", "SellAllItems"),
    SellItem = getRemote("RF", "SellItem"),
    
    -- Favorite
    Favorite = getRemote("RE", "FavoriteItem"),
    FavoriteState = getRemote("RE", "FavoriteStateChanged")
}

-- ===== GUI =====
local gui = Instance.new("ScreenGui")
gui.Name = "MoeGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
header.Parent = mainFrame

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 10)
headerCorner.Parent = header

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0 - FISH IT"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 18
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Menu tabs
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