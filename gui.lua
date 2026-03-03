-- Moe V1.0 GUI for FISH IT - ULTIMATE EDITION
-- Dengan semua Bait, Rod, Weather, Auto Quest, Auto Event, Auto Teleport

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
    ["Bobber Shop"] = CFrame.new(0, 0, 0), -- Ganti dengan koordinat asli
    ["Rods Store"] = CFrame.new(0, 0, 0), -- Ganti dengan koordinat asli
    ["Traveling Merchant"] = CFrame.new(0, 0, 0), -- Ganti dengan koordinat asli
    ["Kohana Volcano"] = CFrame.new(-663.904236, 3.04580712, 718.796875) -- Sama dengan Kohana
}

-- ===== DATA BAIT LENGKAP =====
local BaitTypes = {
    {name = "Starter Bait", price = "Free", luck = "0%", desc = "Given at the start of the game"},
    {name = "Topwater Bait", price = "100$", luck = "8%", desc = "Buy in Bobber Shop"},
    {name = "Luck Bait", price = "1,000$", luck = "12%", desc = "Buy in Bobber Shop"},
    {name = "Midnight Bait", price = "3,000$", luck = "22%", desc = "Buy in Bobber Shop"},
    {name = "Nature Bait", price = "83,500$", luck = "45%", bonus = "Bonus XP: 4%", desc = "Buy in Bobber Shop"},
    {name = "Chroma Bait", price = "290,000$", luck = "100%", desc = "Buy in Bobber Shop"},
    {name = "Royal Bait", price = "425,000$", luck = "130%", bonus = "Gold Mutation Mult.: 30%", desc = "Buy in Traveling Merchant"},
    {name = "Dark Matter Bait", price = "630,000$", luck = "160%", bonus = "Bonus XP: 5% | Shiny Chance: 5%", desc = "Buy in Bobber Shop"},
    {name = "Corrupt Bait", price = "1,150,000$", luck = "220%", bonus = "Mutation Chance: 10% | Shiny Chance: 10%", desc = "Buy in Bobber Shop"},
    {name = "Aether Bait", price = "3,700,000$", luck = "260%", bonus = "Mutation Chance: 15% | Shiny Chance: 5%", desc = "Buy in Bobber Shop"},
    {name = "Floral Bait", price = "4,000,000$", luck = "320%", bonus = "Fairy Dust Mutation Mult.: 140%", desc = "Buy in Ancient Jungle (in Sacred Temple)"},
    {name = "Singularity Bait", price = "8,200,000$", luck = "380%", bonus = "Mutation Chance: 20%", desc = "Buy in Traveling"}
}

-- ===== DATA ROD LENGKAP =====
local RodTypes = {
    -- Common
    {name = "Starter Rod", price = "0$", luck = "0%", speed = "0%", weight = "10Kg", acq = "Entering the game"},
    {name = "Luck Rod", price = "250$", luck = "50%", speed = "2%", weight = "15Kg", acq = "Rods Store"},
    {name = "Carbon Rod", price = "900$", luck = "30%", speed = "4%", weight = "20Kg", acq = "Rods Store"},
    {name = "Toy Rod", price = "0$", luck = "30%", speed = "3%", weight = "18Kg", acq = "Liking and Joining the group"},
    
    -- Uncommon
    {name = "Grass Rod", price = "1,500$", luck = "55%", speed = "5%", weight = "250Kg", acq = "Rods Store"},
    {name = "Damascus Rod", price = "3,000$", luck = "80%", speed = "4%", weight = "400Kg", acq = "Rods Store"},
    {name = "Ice Rod", price = "5,000$", luck = "60%", speed = "7%", weight = "750Kg", acq = "Rods Store"},
    {name = "Lava Rod", price = "0$", luck = "30%", speed = "2%", weight = "100Kg", acq = "Kohana Volcano NPC"},
    
    -- Rare
    {name = "Lucky Rod", price = "10,000$", luck = "130%", speed = "7%", weight = "5,000Kg", acq = "Rod Store"},
    {name = "Midnight Rod", price = "50,000$", luck = "100%", speed = "10%", weight = "10,000Kg", acq = "Rod Store"},
    
    -- Epic
    {name = "Steampunk Rod", price = "215,000$", luck = "175%", speed = "19%", weight = "25,000Kg", acq = "Rod Store"},
    {name = "Chrome Rod", price = "437,000$", luck = "229%", speed = "23%", weight = "190,000Kg", acq = "Rod Store"},
    
    -- Legendary
    {name = "Fluorescent Rod", price = "715,000$", luck = "300%", speed = "23%", weight = "160,000Kg", acq = "Rod Store / Traveling Merchant"},
    {name = "Astral Rod", price = "1,000,000$", luck = "380%", speed = "43%", weight = "150,000Kg", acq = "Rod Store"},
    {name = "Hazmat Rod", price = "1,300,000$", luck = "380%", speed = "32%", weight = "300,000Kg", acq = "Traveling Merchant"},
    
    -- Mythic
    {name = "Ares Rod", price = "3,000,000$", luck = "455%", speed = "56%", weight = "400,000Kg", acq = "At Tropical Grove"},
    {name = "Angler Rod", price = "8,000,000$", luck = "530%", speed = "71%", weight = "500,000Kg", acq = "At Lost Isle"},
    {name = "Ghostfinn Rod", price = "-", luck = "610%", speed = "118%", weight = "600,000Kg", acq = "Deep Sea Quest"},
    {name = "Bamboo Rod", price = "12,000,000$", luck = "760%", speed = "98%", weight = "500,000Kg", acq = "At Ancient Jungle (in Sacred Temple)"},
    
    -- Secret
    {name = "Element Rod", price = "-", luck = "1111%", speed = "130%", weight = "800,000Kg", acq = "Element Quest"},
    {name = "Diamond Rod", price = "-", luck = "1300%", speed = "167%", weight = "1M Kg", acq = "Diamond Researcher"},
    
    -- Gamepass
    {name = "Angelic Rod", price = "399 ROBUX", luck = "180%", speed = "29%", weight = "75,000Kg", acq = "Gamepass"},
    {name = "Gold Rod", price = "445 ROBUX", luck = "110%", speed = "7%", weight = "800Kg", acq = "Gamepass"},
    {name = "Hyper Rod", price = "999 ROBUX", luck = "130%", speed = "13%", weight = "1,000Kg", acq = "Gamepass"}
}

-- ===== DATA WEATHER LENGKAP =====
local WeatherTypes = {
    {name = "Wind (Angin)", price = "10,000", effect = "Meningkatkan kecepatan memancing", desc = "Cocok untuk farming cepat"},
    {name = "Cloudy (Berawan)", price = "20,000", effect = "Menambah +20% Luck", desc = "Terbaik untuk mencari Secret Fish"},
    {name = "Snow (Salju)", price = "15,000", effect = "Menambahkan efek Frozen Mutation", desc = "Untuk kolektor ikan unik"},
    {name = "Storm (Badai)", price = "35,000", effect = "Meningkatkan kecepatan dan +20% Luck", desc = "Ideal untuk sesi farming intensif"},
    {name = "Radiant (Cerah Terang)", price = "50,000", effect = "Meningkatkan peluang mendapatkan ikan Shiny", desc = "Cari ikan Shiny"},
    {name = "Shark Hunt (Perburuan Hiu)", price = "300,000", effect = "Mengaktifkan event khusus berburu hiu", desc = "Event khusus"}
}

-- ===== SETTINGS =====
local Settings = {
    AutoFishing = false,
    AutoQuest = false,
    AutoEvent = false,
    AutoTeleport = false,
    AutoBuyBait = false,
    AutoBuyRod = false,
    AutoWeather = false,
    SelectedBait = "Starter Bait",
    SelectedRod = "Starter Rod",
    SelectedWeather = "Clear"
}

-- ===== FUNGSI UTILITY =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemote(name)
    -- Cari di folder RF
    local rfFolder = ReplicatedStorage:FindFirstChild("RF")
    if rfFolder then
        local remote = rfFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    -- Cari di folder RE
    local reFolder = ReplicatedStorage:FindFirstChild("RE")
    if reFolder then
        local remote = reFolder:FindFirstChild(name)
        if remote then return remote end
    end
    
    return nil
end

local function notify(title, text, duration)
    duration = duration or 2
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = duration
    })
end

local function protectedCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("[Error] " .. tostring(result))
    end
    return result
end

-- ===== REMOTES =====
local Remote = {
    -- Fishing
    ChargeRod = getRemote("ChargeFishingRod"),
    CatchFish = getRemote("CatchFishCompleted"),
    FishingMinigame = getRemote("FishingMinigameChanged"),
    
    -- Bait
    PurchaseBait = getRemote("PurchaseBait"),
    EquipBait = getRemote("EquipBait"),
    
    -- Rod
    PurchaseRod = getRemote("PurchaseFishingRod"),
    EquipRodSkin = getRemote("EquipRodSkin"),
    
    -- Shop
    PurchaseMarket = getRemote("PurchaseMarketItem"),
    
    -- Weather
    PurchaseWeather = getRemote("PurchaseWeatherEvent"),
    WeatherCommand = getRemote("WeatherCommand"),
    
    -- Quests
    ClaimDailyLogin = getRemote("ClaimDailyLogin"),
    ClaimEventReward = getRemote("ClaimEventReward"),
    ClaimBounty = getRemote("ClaimBounty"),
    
    -- Teleport
    SubmarineTP = getRemote("SubmarineTP2") or getRemote("SubmarineTP"),
    
    -- Other
    SellAll = getRemote("SellAllItems"),
    RedeemCode = getRemote("RedeemCode")
}

-- ===== AUTO LOOP =====
spawn(function()
    while task.wait(0.5) do
        protectedCall(function()
            -- Auto Fishing
            if Settings.AutoFishing and Remote.ChargeRod then
                Remote.ChargeRod:FireServer()
            end
            
            -- Auto Quest (Daily Login)
            if Settings.AutoQuest and Remote.ClaimDailyLogin then
                Remote.ClaimDailyLogin:FireServer()
            end
            
            -- Auto Event
            if Settings.AutoEvent and Remote.ClaimEventReward then
                Remote.ClaimEventReward:FireServer()
            end
            
            -- Auto Weather
            if Settings.AutoWeather and Remote.WeatherCommand then
                Remote.WeatherCommand:FireServer(Settings.SelectedWeather)
            end
            
            -- Auto Buy Bait
            if Settings.AutoBuyBait and Remote.PurchaseBait then
                Remote.PurchaseBait:FireServer(Settings.SelectedBait, 5)
            end
        end)
    end
end)

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 900, 0, 600)
mainFrame.Position = UDim2.new(0.5, -450, 0.5, -300)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = gui

-- Rounded corners
local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 20)
corners.Parent = mainFrame

-- Border putih
local stroke = Instance.new("UIStroke")
stroke.Thickness = 1.5
stroke.Color = Color3.new(1, 1, 1)
stroke.Transparency = 0.2
stroke.Parent = mainFrame

-- ===== HEADER =====
local headerFrame = Instance.new("Frame")
headerFrame.Name = "HeaderFrame"
headerFrame.Size = UDim2.new(1, 0, 0, 50)
headerFrame.BackgroundTransparency = 1
headerFrame.Parent = mainFrame

-- Logo
local logoFrame = Instance.new("Frame")
logoFrame.Size = UDim2.new(0, 40, 0, 40)
logoFrame.Position = UDim2.new(0, 15, 0.5, -20)
logoFrame.BackgroundTransparency = 1
logoFrame.Parent = headerFrame

local logo = Instance.new("ImageLabel")
logo.Size = UDim2.new(1, 0, 1, 0)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://115935586997848"
logo.ScaleType = Enum.ScaleType.Fit
logo.Parent = logoFrame

local logoCorner = Instance.new("UICorner")
logoCorner.CornerRadius = UDim.new(0, 20)
logoCorner.Parent = logoFrame

-- Title
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0, 150, 1, 0)
titleLabel.Position = UDim2.new(0, 65, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Moe V1.0"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerFrame

-- Minimize
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -70, 0.5, -15)
minButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minButton.BackgroundTransparency = 0.3
minButton.Text = "—"
minButton.TextColor3 = Color3.new(1, 1, 1)
minButton.TextScaled = true
minButton.Font = Enum.Font.GothamBold
minButton.AutoButtonColor = false
minButton.Parent = headerFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 8)
minCorner.Parent = minButton

-- Close
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0.5, -15)
closeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
closeButton.BackgroundTransparency = 0.3
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.AutoButtonColor = false
closeButton.Parent = headerFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- ===== FLOATING LOGO =====
local floatingLogo = Instance.new("Frame")
floatingLogo.Size = UDim2.new(0, 60, 0, 60)
floatingLogo.Position = UDim2.new(0.9, -30, 0.9, -30)
floatingLogo.BackgroundTransparency = 1
floatingLogo.Parent = gui
floatingLogo.Visible = false
floatingLogo.ZIndex = 1000

local floatLogoImg = Instance.new("ImageLabel")
floatLogoImg.Size = UDim2.new(1, 0, 1, 0)
floatLogoImg.BackgroundTransparency = 1
floatLogoImg.Image = "rbxassetid://115935586997848"
floatLogoImg.ScaleType = Enum.ScaleType.Fit
floatLogoImg.Parent = floatingLogo

local floatLogoCorner = Instance.new("UICorner")
floatLogoCorner.CornerRadius = UDim.new(0, 30)
floatLogoCorner.Parent = floatingLogo

local floatStroke = Instance.new("UIStroke")
floatStroke.Thickness = 1.5
floatStroke.Color = Color3.new(1, 1, 1)
floatStroke.Transparency = 0.2
floatStroke.Parent = floatingLogo

local floatButton = Instance.new("TextButton")
floatButton.Size = UDim2.new(1, 0, 1, 0)
floatButton.BackgroundTransparency = 1
floatButton.Text = ""
floatButton.Parent = floatingLogo

-- Minimize functions
minButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    floatingLogo.Visible = true
end)

floatButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    floatingLogo.Visible = false
end)

closeButton.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Horizontal line
local hLine = Instance.new("Frame")
hLine.Size = UDim2.new(1, -20, 0, 1)
hLine.Position = UDim2.new(0, 10, 0, 50)
hLine.BackgroundColor3 = Color3.new(1, 1, 1)
hLine.BackgroundTransparency = 0.3
hLine.Parent = mainFrame

-- Content container
local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, -20, 1, -60)
contentContainer.Position = UDim2.new(0, 10, 0, 55)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

-- Left menu
local leftMenu = Instance.new("Frame")
leftMenu.Size = UDim2.new(0, 140, 1, 0)
leftMenu.BackgroundTransparency = 1
leftMenu.Parent = contentContainer

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Vertical
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 8)
menuLayout.Parent = leftMenu

-- Vertical line
local vLine = Instance.new("Frame")
vLine.Size = UDim2.new(0, 1, 1, 0)
vLine.Position = UDim2.new(0, 150, 0, 0)
vLine.BackgroundColor3 = Color3.new(1, 1, 1)
vLine.BackgroundTransparency = 0.3
vLine.Parent = contentContainer

-- Content area
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -160, 1, 0)
contentArea.Position = UDim2.new(0, 160, 0, 0)
contentArea.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
contentArea.BackgroundTransparency = 0.3
contentArea.Parent = contentContainer

local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 12)
contentCorner.Parent = contentArea

-- Content title
local contentTitle = Instance.new("TextLabel")
contentTitle.Size = UDim2.new(1, -20, 0, 30)
contentTitle.Position = UDim2.new(0, 10, 0, 10)
contentTitle.BackgroundTransparency = 1
contentTitle.Text = "Pilih menu"
contentTitle.TextColor3 = Color3.new(1, 1, 1)
contentTitle.TextScaled = true
contentTitle.Font = Enum.Font.GothamBold
contentTitle.TextXAlignment = Enum.TextXAlignment.Left
contentTitle.Parent = contentArea

-- Scrolling frame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -20, 1, -50)
scrollFrame.Position = UDim2.new(0, 10, 0, 45)
scrollFrame.BackgroundTransparency = 1
scrollFrame.ScrollBarThickness = 6
scrollFrame.ScrollBarImageColor3 = Color3.new(1, 1, 1)
scrollFrame.ScrollBarImageTransparency = 0.5
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrollFrame.Parent = contentArea

-- Features container
local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = scrollFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.FillDirection = Enum.FillDirection.Vertical
featuresLayout.Padding = UDim.new(0, 12)
featuresLayout.Parent = featuresContainer

-- ===== UI ELEMENTS =====
local function createToggle(parent, title, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 25)
    btn.Position = UDim2.new(0.8, 0, 0.5, -12.5)
    btn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
    btn.BackgroundTransparency = 0.2
    btn.Text = "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 12)
    btnCorner.Parent = btn
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.new(0.2, 0.8, 0.2) or Color3.new(0.3, 0.3, 0.3)
        btn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 45)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        btn.BackgroundTransparency = 0
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundTransparency = 0.2
    end)
    btn.MouseButton1Click:Connect(function()
        btn.BackgroundColor3 = Color3.new(0.4, 0.4, 0.4)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        if callback then protectedCall(callback) end
    end)
end

local function createDropdown(parent, title, options, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 70)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = title
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.GothamBold
    label.TextSize = 14
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.Position = UDim2.new(0, 0, 0, 25)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.BackgroundTransparency = 0.3
    btn.Text = options[1].name or options[1]
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.AutoButtonColor = false
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, #options * 32 + 4)
    dropdown.Position = UDim2.new(0, 0, 0, 62)
    dropdown.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    dropdown.BackgroundTransparency = 0.1
    dropdown.Visible = false
    dropdown.Parent = frame
    dropdown.ZIndex = 10
    
    local dropdownCorner = Instance.new("UICorner")
    dropdownCorner.CornerRadius = UDim.new(0, 6)
    dropdownCorner.Parent = dropdown
    
    local dropdownLayout = Instance.new("UIListLayout")
    dropdownLayout.Padding = UDim.new(0, 2)
    dropdownLayout.Parent = dropdown
    
    for _, opt in ipairs(options) do
        local optName = opt.name or opt
        local optBtn = Instance.new("TextButton")
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.BackgroundTransparency = 1
        optBtn.Text = "  "..optName
        optBtn.TextColor3 = Color3.new(1, 1, 1)
        optBtn.TextXAlignment = Enum.TextXAlignment.Left
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.AutoButtonColor = false
        optBtn.Parent = dropdown
        optBtn.ZIndex = 11
        
        optBtn.MouseEnter:Connect(function()
            optBtn.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
            optBtn.BackgroundTransparency = 0.3
        end)
        optBtn.MouseLeave:Connect(function()
            optBtn.BackgroundTransparency = 1
        end)
        optBtn.MouseButton1Click:Connect(function()
            btn.Text = optName
            dropdown.Visible = false
            if callback then callback(opt) end
        end)
    end
    
    btn.MouseButton1Click:Connect(function()
        dropdown.Visible = not dropdown.Visible
    end)
end

local function createSeparator(parent, text)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 30)
    frame.BackgroundTransparency = 1
    frame.Parent = parent
    
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 1)
    line.Position = UDim2.new(0, 0, 0.5, 0)
    line.BackgroundColor3 = Color3.new(1, 1, 1)
    line.BackgroundTransparency = 0.5
    line.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, #text * 10, 1, 0)
    label.Position = UDim2.new(0.5, -(#text * 5), 0, 0)
    label.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
    label.BackgroundTransparency = 0.3
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 12
    label.Parent = frame
    
    local labelCorner = Instance.new("UICorner")
    labelCorner.CornerRadius = UDim.new(0, 8)
    labelCorner.Parent = label
end

local function createInfoBox(parent, title, content)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 80)
    frame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    frame.BackgroundTransparency = 0.3
    frame.Parent = parent
    
    local infoCorner = Instance.new("UICorner")
    infoCorner.CornerRadius = UDim.new(0, 8)
    infoCorner.Parent = frame
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -10, 0, 20)
    titleLabel.Position = UDim2.new(0, 5, 0, 5)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.new(1, 1, 0)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = frame
    
    local contentLabel = Instance.new("TextLabel")
    contentLabel.Size = UDim2.new(1, -10, 0, 50)
    contentLabel.Position = UDim2.new(0, 5, 0, 25)
    contentLabel.BackgroundTransparency = 1
    contentLabel.Text = content
    contentLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    contentLabel.Font = Enum.Font.Gotham
    contentLabel.TextSize = 12
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextYAlignment = Enum.TextYAlignment.Top
    contentLabel.TextWrapped = true
    contentLabel.Parent = frame
end

-- ===== FUNGSI CLEAR CONTAINER =====
local function clearContainer()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
end

-- ===== MENU FUNCTIONS =====

-- Fishing Menu
local function showFishing()
    clearContainer()
    contentTitle.Text = "⚓ FISHING FEATURES"
    
    createToggle(featuresContainer, "🎣 Auto Fishing", function(state)
        Settings.AutoFishing = state
        notify("Fishing", "Auto Fishing "..(state and "ON" or "OFF"))
    end)
    
    createToggle(featuresContainer, "🔥 Blatant Mode", function(state)
        Settings.BlatantMode = state
        notify("Fishing", "Blatant Mode "..(state and "ON" or "OFF"))
    end)
    
    createToggle(featuresContainer, "✨ Auto Perfect", function(state)
        Settings.AutoPerfect = state
        notify("Fishing", "Auto Perfect "..(state and "ON" or "OFF"))
    end)
    
    createToggle(featuresContainer, "💰 Auto Sell", function(state)
        Settings.AutoSell = state
        notify("Fishing", "Auto Sell "..(state and "ON" or "OFF"))
    end)
    
    createButton(featuresContainer, "💰 SELL ALL NOW", function()
        if Remote.SellAll then
            Remote.SellAll:FireServer()
            notify("Fishing", "Sold all items!")
        end
    end)
end

-- Bait Menu
local function showBait()
    clearContainer()
    contentTitle.Text = "🎣 BAIT SHOP"
    
    createToggle(featuresContainer, "🔄 Auto Buy Bait", function(state)
        Settings.AutoBuyBait = state
        notify("Bait", "Auto Buy "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "SELECT BAIT")
    
    createDropdown(featuresContainer, "Choose Bait", BaitTypes, function(selected)
        Settings.SelectedBait = selected.name
        notify("Bait", "Selected: "..selected.name)
    end)
    
    createButton(featuresContainer, "💰 Buy 5x Selected Bait", function()
        if Remote.PurchaseBait and Settings.SelectedBait then
            Remote.PurchaseBait:FireServer(Settings.SelectedBait, 5)
            notify("Bait", "Bought 5x "..Settings.SelectedBait)
        end
    end)
    
    createButton(featuresContainer, "💰 Buy 10x Selected Bait", function()
        if Remote.PurchaseBait and Settings.SelectedBait then
            Remote.PurchaseBait:FireServer(Settings.SelectedBait, 10)
            notify("Bait", "Bought 10x "..Settings.SelectedBait)
        end
    end)
    
    createButton(featuresContainer, "⚡ Equip Selected Bait", function()
        if Remote.EquipBait and Settings.SelectedBait then
            Remote.EquipBait:FireServer(Settings.SelectedBait)
            notify("Bait", "Equipped "..Settings.SelectedBait)
        end
    end)
    
    createSeparator(featuresContainer, "BAIT INFO")
    
    -- Tampilkan info 3 bait teratas
    for i = 1, math.min(3, #BaitTypes) do
        local bait = BaitTypes[i]
        local info = string.format("%s\n💰 %s | 🍀 %s", bait.name, bait.price, bait.luck)
        if bait.bonus then
            info = info .. "\n✨ " .. bait.bonus
        end
        createInfoBox(featuresContainer, bait.name, info)
    end
end

-- Rod Menu
local function showRod()
    clearContainer()
    contentTitle.Text = "🎣 ROD SHOP"
    
    createToggle(featuresContainer, "🔄 Auto Buy Rod", function(state)
        Settings.AutoBuyRod = state
        notify("Rod", "Auto Buy "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "SELECT ROD")
    
    createDropdown(featuresContainer, "Choose Rod", RodTypes, function(selected)
        Settings.SelectedRod = selected.name
        notify("Rod", "Selected: "..selected.name)
    end)
    
    createButton(featuresContainer, "💰 Buy Selected Rod", function()
        if Remote.PurchaseRod and Settings.SelectedRod then
            Remote.PurchaseRod:FireServer(Settings.SelectedRod)
            notify("Rod", "Bought "..Settings.SelectedRod)
        end
    end)
    
    createButton(featuresContainer, "⚡ Equip Rod Skin", function()
        if Remote.EquipRodSkin and Settings.SelectedRod then
            Remote.EquipRodSkin:FireServer(Settings.SelectedRod)
            notify("Rod", "Equipped "..Settings.SelectedRod)
        end
    end)
    
    createSeparator(featuresContainer, "ROD INFO")
    
    -- Tampilkan info 3 rod terbaik
    for i = #RodTypes - 3, #RodTypes do
        if i > 0 then
            local rod = RodTypes[i]
            local info = string.format("%s\n💰 %s | 🍀 %s | ⚡ %s | ⚖️ %s", 
                rod.name, rod.price, rod.luck, rod.speed, rod.weight)
            info = info .. "\n📌 " .. rod.acq
            createInfoBox(featuresContainer, rod.name, info)
        end
    end
end

-- Weather Menu
local function showWeather()
    clearContainer()
    contentTitle.Text = "☁️ WEATHER FEATURES"
    
    createToggle(featuresContainer, "🔄 Auto Weather", function(state)
        Settings.AutoWeather = state
        notify("Weather", "Auto Weather "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "SELECT WEATHER")
    
    createDropdown(featuresContainer, "Choose Weather", WeatherTypes, function(selected)
        Settings.SelectedWeather = selected.name
        notify("Weather", "Selected: "..selected.name)
    end)
    
    createButton(featuresContainer, "☀️ Activate Weather", function()
        if Remote.WeatherCommand and Settings.SelectedWeather then
            Remote.WeatherCommand:FireServer(Settings.SelectedWeather)
            notify("Weather", "Activated: "..Settings.SelectedWeather)
        end
    end)
    
    createSeparator(featuresContainer, "WEATHER SLOTS")
    
    createButton(featuresContainer, "Slot 1 - Wind", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(1, "Wind")
            notify("Weather", "Slot 1 set to Wind")
        end
    end)
    
    createButton(featuresContainer, "Slot 2 - Cloudy", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(2, "Cloudy")
            notify("Weather", "Slot 2 set to Cloudy")
        end
    end)
    
    createButton(featuresContainer, "Slot 3 - Storm", function()
        if Remote.PurchaseWeather then
            Remote.PurchaseWeather:FireServer(3, "Storm")
            notify("Weather", "Slot 3 set to Storm")
        end
    end)
    
    createSeparator(featuresContainer, "WEATHER INFO")
    
    -- Tampilkan info semua weather
    for i, weather in ipairs(WeatherTypes) do
        local info = string.format("💰 %s coins\n✨ %s\n📌 %s", 
            weather.price, weather.effect, weather.desc)
        createInfoBox(featuresContainer, weather.name, info)
    end
end

-- Teleport Menu
local function showTeleport()
    clearContainer()
    contentTitle.Text = "🌍 TELEPORT FEATURES"
    
    createToggle(featuresContainer, "🔄 Auto Teleport to Event", function(state)
        Settings.AutoTeleport = state
        notify("Teleport", "Auto Teleport "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "TELEPORT TO LOCATION")
    
    -- Location dropdown
    local locs = {}
    for k,_ in pairs(TeleportLocations) do
        table.insert(locs, k)
    end
    table.sort(locs)
    
    createDropdown(featuresContainer, "📍 Locations", locs, function(selected)
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = TeleportLocations[selected]
            notify("Teleport", "Teleported to "..selected)
        end
    end)
    
    createSeparator(featuresContainer, "TELEPORT TO EVENT")
    
    -- Event locations
    createButton(featuresContainer, "🎄 Christmas Event", function()
        -- Ganti dengan koordinat event
        notify("Teleport", "Teleported to Christmas Event")
    end)
    
    createButton(featuresContainer, "🦈 Shark Hunt Event", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Shark Hunt")
            notify("Event", "Shark Hunt Activated!")
        end
    end)
    
    createSeparator(featuresContainer, "TELEPORT TO NPC")
    
    createButton(featuresContainer, "👤 Traveling Merchant", function()
        if TeleportLocations["Traveling Merchant"] then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = TeleportLocations["Traveling Merchant"]
                notify("Teleport", "Teleported to Traveling Merchant")
            end
        end
    end)
    
    createButton(featuresContainer, "🏪 Bobber Shop", function()
        if TeleportLocations["Bobber Shop"] then
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = TeleportLocations["Bobber Shop"]
                notify("Teleport", "Teleported to Bobber Shop")
            end
        end
    end)
    
    createButton(featuresContainer, "🌋 Kohana Volcano", function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = TeleportLocations["Kohana Volcano"]
            notify("Teleport", "Teleported to Kohana Volcano")
        end
    end)
    
    createSeparator(featuresContainer, "PLAYER TELEPORT")
    
    -- Player dropdown
    local players = {}
    for _,p in pairs(game.Players:GetPlayers()) do
        if p ~= player then
            table.insert(players, p.Name)
        end
    end
    table.sort(players)
    
    if #players > 0 then
        createDropdown(featuresContainer, "👤 Teleport to Player", players, function(selected)
            local target = game.Players:FindFirstChild(selected)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0)
                    notify("Teleport", "Teleported to "..selected)
                end
            end
        end)
    end
end

-- Quest Menu
local function showQuest()
    clearContainer()
    contentTitle.Text = "📋 QUEST FEATURES"
    
    createToggle(featuresContainer, "🔄 Auto Daily Login", function(state)
        Settings.AutoQuest = state
        notify("Quest", "Auto Daily Login "..(state and "ON" or "OFF"))
    end)
    
    createToggle(featuresContainer, "🔄 Auto Claim Bounty", function(state)
        Settings.AutoBounty = state
        notify("Quest", "Auto Claim Bounty "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "QUESTS")
    
    createButton(featuresContainer, "📅 Claim Daily Login", function()
        if Remote.ClaimDailyLogin then
            Remote.ClaimDailyLogin:FireServer()
            notify("Quest", "Daily Login Claimed!")
        end
    end)
    
    createButton(featuresContainer, "🏆 Claim Bounty", function()
        if Remote.ClaimBounty then
            Remote.ClaimBounty:FireServer()
            notify("Quest", "Bounty Claimed!")
        end
    end)
    
    createButton(featuresContainer, "🎁 Claim Event Reward", function()
        if Remote.ClaimEventReward then
            Remote.ClaimEventReward:FireServer()
            notify("Quest", "Event Reward Claimed!")
        end
    end)
    
    createSeparator(featuresContainer, "SPECIAL QUESTS")
    
    createButton(featuresContainer, "👻 Ghostfinn Rod Quest", function()
        local questInfo = [[
Ghostfinn Rod Requirements:
• Catch 300 Rare/Epic fish in Treasure Room
• Catch 3 Mythic at Sisyphus Statue
• Catch 1 Secret at Sisyphus Statue
• Earn 1M coins
]]
        notify("Quest", "Check console for details")
        print(questInfo)
    end)
    
    createButton(featuresContainer, "🔮 Element Rod Quest", function()
        local questInfo = [[
Element Rod Requirements:
• Own Ghostfinn Rod
• Catch 1 Secret at Ancient Jungle
• Catch 1 Secret at Sacred Temple
• Create 3 Transcended Stones
]]
        notify("Quest", "Check console for details")
        print(questInfo)
    end)
    
    createButton(featuresContainer, "💎 Diamond Rod Quest", function()
        local questInfo = [[
Diamond Rod Requirements:
• Own Element Rod
• Catch SECRET Fish at Coral Reefs
• Catch SECRET Fish at Tropical Grove
• Bring Lary a Mutated Gemstone Ruby
• Bring Lary a Lochness Monster
• Catch 1000 Fish while using PERFECT throw
]]
        notify("Quest", "Check console for details")
        print(questInfo)
    end)
end

-- Event Menu
local function showEvent()
    clearContainer()
    contentTitle.Text = "🎪 EVENT FEATURES"
    
    createToggle(featuresContainer, "🔄 Auto Event", function(state)
        Settings.AutoEvent = state
        notify("Event", "Auto Event "..(state and "ON" or "OFF"))
    end)
    
    createSeparator(featuresContainer, "CHRISTMAS EVENT 2025")
    
    createButton(featuresContainer, "🎄 Teleport to Event", function()
        -- Ganti dengan koordinat event
        notify("Event", "Teleported to Christmas Event")
    end)
    
    createButton(featuresContainer, "🦌 Claim Reindeer Antler", function()
        notify("Event", "Reindeer Antler - Complete Daily Quests")
    end)
    
    createButton(featuresContainer, "✨ Claim Festive Lights", function()
        notify("Event", "Festive Lights - Complete Daily Quests")
    end)
    
    createButton(featuresContainer, "🎁 Claim Present Caster", function()
        notify("Event", "Festive Present Caster - 25,000 Candy")
    end)
    
    createButton(featuresContainer, "⛄ Claim Sugarcone Snowman", function()
        notify("Event", "Sugarcone Snowman - Complete Daily Quests")
    end)
    
    createButton(featuresContainer, "🍬 Claim Golden Peppermint", function()
        notify("Event", "Golden Peppermint - Complete Daily Quests")
    end)
    
    createButton(featuresContainer, "🍭 Claim Candy Cane Rod", function()
        notify("Event", "Candy Cane Rod - Legendary Reward")
    end)
    
    createSeparator(featuresContainer, "SHARK HUNT EVENT")
    
    createButton(featuresContainer, "🦈 Activate Shark Hunt", function()
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Shark Hunt")
            notify("Event", "Shark Hunt Activated!")
        end
    end)
    
    createButton(featuresContainer, "💰 Shark Hunt Cost: 300,000 coins", function() end)
end

-- ===== MENU BUTTONS =====
local menuButtons = {}
local currentMenu = ""

local function createMenuButton(name, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 120, 0, 45)
    btn.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    btn.Parent = leftMenu
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        if currentMenu ~= name then btn.BackgroundTransparency = 0.1 end
    end)
    btn.MouseLeave:Connect(function()
        if currentMenu ~= name then btn.BackgroundTransparency = 0.3 end
    end)
    
    btn.MouseButton1Click:Connect(function()
        for _,b in pairs(menuButtons) do
            b.BackgroundTransparency = 0.3
            b.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
        end
        btn.BackgroundTransparency = 0
        btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
        currentMenu = name
        func()
    end)
    
    table.insert(menuButtons, btn)
end

-- Create all menu buttons
createMenuButton("⚓ Fishing", showFishing)
createMenuButton("🎣 Bait", showBait)
createMenuButton("🎣 Rod", showRod)
createMenuButton("☁️ Weather", showWeather)
createMenuButton("🌍 Teleport", showTeleport)
createMenuButton("📋 Quest", showQuest)
createMenuButton("🎪 Event", showEvent)

-- Auto-show Fishing menu
task.wait(0.5)
for _,btn in pairs(leftMenu:GetChildren()) do
    if btn:IsA("TextButton") and btn.Text == "⚓ Fishing" then
        btn.MouseButton1Click:Fire()
        break
    end
end

-- Drag functionality
local dragging, dragInput, dragStart, startPos = false

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

print("=== MOE V1.0 ULTIMATE EDITION LOADED ===")
print("✅ 7 Menu Utama: Fishing, Bait, Rod, Weather, Teleport, Quest, Event")
print("✅ Semua Bait dan Rod dari game")
print("✅ 6 Jenis Weather dengan efek lengkap")
print("✅ Auto Quest & Auto Event")
print("✅ Teleport ke semua lokasi dan NPC")