-- Moe V1.0 GUI for FISH IT - ADVANCED EXPLOIT EDITION
-- Fokus pada bagian paling ribet untuk developer

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
    ["Spawn"] = CFrame.new(45.2788086, 252.562927, 2987.10913, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Sisyphus Statue"] = CFrame.new(-3728.21606, -135.074417, -1012.12744, -0.977224171, 7.74980258e-09, -0.212209702, 1.566994e-08, 1, -3.5640408e-08, 0.212209702, -3.81539813e-08, -0.977224171),
    ["Coral Reefs"] = CFrame.new(-3114.78198, 1.32066584, 2237.52295, -0.304758579, 1.6556676e-08, -0.952429652, -8.50574935e-08, 1, 4.46003305e-08, 0.952429652, 9.46036067e-08, -0.304758579),
    ["Esoteric Depths"] = CFrame.new(3248.37109, -1301.53027, 1403.82727, -0.920208454, 7.76270355e-08, 0.391428679, 4.56261056e-08, 1, -9.10549289e-08, -0.391428679, -6.5930152e-08, -0.920208454),
    ["Crater Island"] = CFrame.new(1016.49072, 20.0919304, 5069.27295, 0.838976264, 3.30379857e-09, -0.544168055, 2.63538391e-09, 1, 1.01344115e-08, 0.544168055, -9.93662219e-09, 0.838976264),
    ["Lost Isle"] = CFrame.new(-3618.15698, 240.836655, -1317.45801, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Weather Machine"] = CFrame.new(-1488.51196, 83.1732635, 1876.30298, 1, 0, 0, 0, 1, 0, 0, 0, 1),
    ["Tropical Grove"] = CFrame.new(-2095.34106, 197.199997, 3718.08008),
    ["Mount Hallow"] = CFrame.new(2136.62305, 78.9163895, 3272.50439, -0.977613986, -1.77645827e-08, 0.210406482, -2.42338203e-08, 1, -2.81680421e-08, -0.210406482, -3.26364251e-08, -0.977613986),
    ["Treasure Room"] = CFrame.new(-3606.34985, -266.57373, -1580.97339, 0.998743415, 1.12141152e-13, -0.0501160324, -1.56847693e-13, 1, -8.88127842e-13, 0.0501160324, 8.94872392e-13, 0.998743415),
    ["Kohana"] = CFrame.new(-663.904236, 3.04580712, 718.796875, -0.100799225, -2.14183729e-08, -0.994906783, -1.12300391e-08, 1, -2.03902459e-08, 0.994906783, 9.11752096e-09, -0.100799225),
    ["Underground Cellar"] = CFrame.new(2109.52148, -94.1875076, -708.609131, 0.418592364, 3.34794485e-08, -0.908174217, -5.24141512e-08, 1, 1.27060247e-08, 0.908174217, 4.22825366e-08, 0.418592364),
    ["Ancient Jungle"] = CFrame.new(1831.71362, 6.62499952, -299.279175, 0.213522509, 1.25553285e-07, -0.976938128, -4.32026184e-08, 1, 1.19074642e-07, 0.976938128, 1.67811702e-08, 0.213522509),
    ["Sacred Temple"] = CFrame.new(1466.92151, -21.8750591, -622.835693, -0.764787138, 8.14444334e-09, 0.644283056, 2.31097452e-08, 1, 1.4791004e-08, -0.644283056, 2.6201187e-08, -0.764787138)
}

local TeleportNames = {}
for name, _ in pairs(TeleportLocations) do
    table.insert(TeleportNames, name)
end
table.sort(TeleportNames)

-- ===== DATA UNTUK EXPLOIT =====
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

local WeatherNames = {
    "Wind", "Cloudy", "Snow", "Storm", "Radiant", "Shark Hunt"
}

-- ===== REMOTE FUNCTIONS DENGAN HASH =====
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function getRemoteFromPackages(folder, hashName)
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    if not packages then return nil end
    
    if folder == "RF" then
        local rf = packages:FindFirstChild("RF")
        if rf then
            return rf:FindFirstChild(hashName)
        end
    elseif folder == "RE" then
        local re = packages:FindFirstChild("RE")
        if re then
            return re:FindFirstChild(hashName)
        end
    end
    return nil
end

local Remote = {
    -- Fishing
    CatchFish = getRemoteFromPackages("RF", "76b3e3c8c811abe6c6ef36d0f6ec91de75fffd97bff713a4cb421303410ccb84"),
    ChargeRod = getRemoteFromPackages("RF", "aae67692fc443eb0cd6545ac1a4069ced9a4285e239b3e6b7d323b7d17070b5a"),
    FishingMinigame = getRemoteFromPackages("RE", "609e281eb1fbf03c9f0721e7dde16b73b4d06ff1fec785fe4db2dfe51e9a0caa"),
    
    -- RNG & Stats
    UpdateAutoFishingState = getRemoteFromPackages("RF", "94f69d1fe654653d32e8ce264d0510234dfad1f597f1e8026b89a35e7aeb977b"),
    UpdateFishingRadar = getRemoteFromPackages("RF", "e891e49139efacafbe0b8985e76925ad48731386926a299333acf4e79436751b"),
    UpdateAutoSellThreshold = getRemoteFromPackages("RF", "6648b1e3b7a67a01afd03d3318cd0269c0726fb80a6985c5b8d10dfd20c08fac"),
    
    -- Purchase
    PurchaseBait = getRemoteFromPackages("RF", "749e74fbc5fc3d196df3235c7e0e96639484e875de7bfe82629d1b86a0c6f01d"),
    PurchaseRod = getRemoteFromPackages("RF", "631361fdb4712a1bbd2df65a1c5fd948e6f85e5f30ef746c022a4ba1bf5c3399"),
    PurchaseWeather = getRemoteFromPackages("RF", "f7df2819493cf037d3870073bcb17495569565c5a08c7bd2b3632f440a361335"),
    
    -- Claim
    ClaimDaily = getRemoteFromPackages("RF", "91f555bbe3531dd9d8461f63f1b5ed9fdfe8275e29df3d6b4bf50d016c58cf6e"),
    ClaimBounty = getRemoteFromPackages("RF", "970dc117e86b893579c095f746bfd11bb5ad743effa48a4b11f9b3acaab40e1b"),
    ClaimEvent = getRemoteFromPackages("RE", "3205d5ea83639e08c73e6c8a2605acf32e604bd7785761e488cbf47971cd9021"),
    
    -- Sell
    SellAll = getRemoteFromPackages("RF", "478362a898e12ac6421d7a6b918dab8385b48c04cfaba211fdb6dd48111107e6"),
    SellItem = getRemoteFromPackages("RF", "61ac0f04b309d722f1df60502b90edcd4bca7cd395c192e06bc5497d5ce0b598"),
    
    -- Weather & Teleport
    WeatherCommand = getRemoteFromPackages("RE", "33e2a9e4854072028b2dc6cb66fe1365ad2d0bebf72421f844ccb80e780e2f4f"),
    SubmarineTP = getRemoteFromPackages("RE", "08ad2bcf5a0af3edb493588043f0a994dd33514a272a67578891ad2a6be01671"),
    
    -- Potion & Buff
    ConsumePotion = getRemoteFromPackages("RF", "9d6f9a67eecd6285efabf46e099b4514e0b92f1c2ab04529ab5c446cc3e5f449"),
    ActivateLuck = getRemoteFromPackages("RE", "f9b04b9f4b0e13bd3b79a804ae780ae3d6c1afee20b8c5fb439db5a08e6ea52a"),
    
    -- Inventory
    UseGift = getRemoteFromPackages("RF", "93e7bd4ee545856c489046f58d520b38f9960a9f438d20ac7d3c9bf9fdac5da3"),
    FavoriteItem = getRemoteFromPackages("RE", "164aa91f67a8713d9a2f93fcc48a1af4fec6205548bd36621d505097f9394037"),
}

-- ===== NOTIFY =====
local function notify(title, text)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Duration = 2
    })
end

-- ===== UI ELEMENTS =====
local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = Color3.new(0.25, 0.25, 0.25)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(callback)
end

local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 25)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1, 1, 1)
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
end

local function createDropdown(parent, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 35)
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
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = frame
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Size = UDim2.new(1, 0, 0, 0)
    dropdownFrame.Position = UDim2.new(0, 0, 0, 35)
    dropdownFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    dropdownFrame.Visible = false
    dropdownFrame.Parent = frame
    dropdownFrame.ZIndex = 10
    dropdownFrame.AutomaticSize = Enum.AutomaticSize.Y
    
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

-- ===== MAIN FRAME =====
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BackgroundTransparency = 0.15
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui

local corners = Instance.new("UICorner")
corners.CornerRadius = UDim.new(0, 12)
corners.Parent = mainFrame

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundTransparency = 1
header.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 150, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Moe V1.0"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 5)
closeBtn.BackgroundColor3 = Color3.new(1, 0.3, 0.3)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = header
closeBtn.MouseButton1Click:Connect(function() gui:Destroy() end)

-- Content
local contentFrame = Instance.new("ScrollingFrame")
contentFrame.Size = UDim2.new(1, -20, 1, -60)
contentFrame.Position = UDim2.new(0, 10, 0, 50)
contentFrame.BackgroundTransparency = 1
contentFrame.ScrollBarThickness = 4
contentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
contentFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentFrame.Parent = mainFrame

local featuresContainer = Instance.new("Frame")
featuresContainer.Size = UDim2.new(1, 0, 0, 0)
featuresContainer.BackgroundTransparency = 1
featuresContainer.Parent = contentFrame
featuresContainer.AutomaticSize = Enum.AutomaticSize.Y

local featuresLayout = Instance.new("UIListLayout")
featuresLayout.Padding = UDim.new(0, 8)
featuresLayout.Parent = featuresContainer

-- ===== CLEAR FEATURES =====
local function clearFeatures()
    for _, child in pairs(featuresContainer:GetChildren()) do
        if child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") then
            child:Destroy()
        end
    end
end

-- ===== 🎯 EXPLOIT 1: RNG MODIFIER STACKING =====
-- Developer paling ribet: Menghitung total Luck dari berbagai sumber
local function exploitRNGStacking()
    clearFeatures()
    
    createLabel(featuresContainer, "🎲 RNG MODIFIER STACKING")
    createLabel(featuresContainer, "Target: Stack Luck + Weather + Event + Potion")
    
    createButton(featuresContainer, "⚠️ ACTIVATE ALL BUFFS", function()
        -- Stack semua kemungkinan buff
        if Remote.ActivateLuck then
            Remote.ActivateLuck:FireServer(true)
        end
        
        if Remote.ConsumePotion then
            Remote.ConsumePotion:FireServer("Luck Potion")
            Remote.ConsumePotion:FireServer("Rare Potion")
            Remote.ConsumePotion:FireServer("Legendary Potion")
        end
        
        if Remote.WeatherCommand then
            Remote.WeatherCommand:FireServer("Radiant") -- +Shiny chance
            Remote.WeatherCommand:FireServer("Storm") -- +Luck
        end
        
        notify("RNG", "All buffs activated - Cek luck increase")
    end)
    
    createButton(featuresContainer, "⚡ OVERFLOW LUCK TEST", function()
        -- Coba buat luck overflow (kalau server pake integer)
        for i = 1, 100 do
            spawn(function()
                Remote.ActivateLuck:FireServer(true)
            end)
        end
    end)
    
    createLabel(featuresContainer, "📊 Teori:")
    createLabel(featuresContainer, "• Luck + Weather + Event + Potion")
    createLabel(featuresContainer, "• Developer harus hitung semua")
    createLabel(featuresContainer, "• Kalau overflow? Bisa jadi 0 atau negatif")
end

-- ===== 🎯 EXPLOIT 2: AUTO FISHING VS MANUAL FISHING =====
-- Developer ribet: Sinkronisasi state
local function exploitAutoManual()
    clearFeatures()
    
    createLabel(featuresContainer, "🎣 AUTO VS MANUAL STATE")
    createLabel(featuresContainer, "Target: Konflik state Auto/Manual")
    
    createButton(featuresContainer, "⚠️ START AUTO FISHING", function()
        if Remote.UpdateAutoFishingState then
            Remote.UpdateAutoFishingState:FireServer(true)
        end
    end)
    
    createButton(featuresContainer, "⚡ CAST MANUAL (SAME TIME)", function()
        if Remote.ChargeRod then
            Remote.ChargeRod:FireServer()
        end
    end)
    
    createButton(featuresContainer, "🔥 RACE CONDITION", function()
        -- Kirim auto dan manual bersamaan
        for i = 1, 20 do
            spawn(function()
                if Remote.UpdateAutoFishingState then
                    Remote.UpdateAutoFishingState:FireServer(true)
                end
            end)
            spawn(function()
                if Remote.ChargeRod then
                    Remote.ChargeRod:FireServer()
                end
            end)
        end
    end)
    
    createLabel(featuresContainer, "📊 Teori:")
    createLabel(featuresContainer, "• State machine complex")
    createLabel(featuresContainer, "• Auto vs Manual conflict")
    createLabel(featuresContainer, "• Bisa double catch atau free catch")
end

-- ===== 🎯 EXPLOIT 3: INVENTORY LIMIT BYPASS =====
-- Developer ribet: Inventory management
local function exploitInventory()
    clearFeatures()
    
    createLabel(featuresContainer, "📦 INVENTORY LIMIT BYPASS")
    createLabel(featuresContainer, "Target: Melebihi stack limit / inventory size")
    
    createButton(featuresContainer, "⚠️ SPAM PURCHASE", function()
        if not Remote.PurchaseBait then return end
        
        for i = 1, 1000 do
            spawn(function()
                Remote.PurchaseBait:FireServer("Starter Bait", 999)
            end)
        end
    end)
    
    createButton(featuresContainer, "⚡ GIFT SPAM", function()
        if Remote.UseGift then
            for i = 1, 100 do
                spawn(function()
                    Remote.UseGift:FireServer("Gift Box")
                end)
            end
        end
    end)
    
    createButton(featuresContainer, "🔥 SELL WHILE FULL", function()
        -- Jual di tengah-tengah spam
        if Remote.SellAll then
            Remote.SellAll:FireServer()
        end
    end)
    
    createLabel(featuresContainer, "📊 Teori:")
    createLabel(featuresContainer, "• Inventory limit check")
    createLabel(featuresContainer, "• Race condition pas penuh")
    createLabel(featuresContainer, "• Bisa overflow inventory")
end

-- ===== 🎯 EXPLOIT 4: TRADING SYSTEM BYPASS =====
-- Developer ribet: Trade validation
local function exploitTrading()
    clearFeatures()
    
    createLabel(featuresContainer, "🔄 TRADING SYSTEM")
    createLabel(featuresContainer, "Target: Duplicate items via trade")
    
    createButton(featuresContainer, "⚠️ SEND TRADE REQUEST", function()
        if Remote.ClaimBounty then
            -- Coba kirim request trade (kalau ada)
            Remote.ClaimBounty:FireServer()
        end
    end)
    
    createButton(featuresContainer, "⚡ ACCEPT TRADE WHILE LAGGING", function()
        -- Simulasi lag saat trade
        for i = 1, 10 do
            spawn(function()
                if Remote.ClaimBounty then
                    Remote.ClaimBounty:FireServer()
                end
                task.wait(0.01)
                if Remote.SellAll then
                    Remote.SellAll:FireServer()
                end
            end)
        end
    end)
    
    createLabel(featuresContainer, "📊 Teori:")
    createLabel(featuresContainer, "• Trade validation complex")
    createLabel(featuresContainer, "• Lag bisa bikin double item")
    createLabel(featuresContainer, "• Cancel trade di tengah proses")
end

-- ===== 🎯 EXPLOIT 5: WEATHER + EVENT STACK =====
-- Developer ribet: Event duration & stacking
local function exploitWeatherEvent()
    clearFeatures()
    
    createLabel(featuresContainer, "☁️ WEATHER + EVENT STACK")
    createLabel(featuresContainer, "Target: Stack multiple weather/event")
    
    createButton(featuresContainer, "⚠️ STACK ALL WEATHER", function()
        if not Remote.WeatherCommand then return end
        
        local weathers = {"Radiant", "Storm", "Shark Hunt", "Fog"}
        for _, w in ipairs(weathers) do
            spawn(function()
                Remote.WeatherCommand:FireServer(w)
            end)
        end
    end)
    
    createButton(featuresContainer, "⚡ EXTEND DURATION", function()
        -- Coba perpanjang durasi dengan spam
        for i = 1, 50 do
            spawn(function()
                Remote.WeatherCommand:FireServer("Shark Hunt")
            end)
        end
    end)
    
    createLabel(featuresContainer, "📊 Teori:")
    createLabel(featuresContainer, "• Weather duration tracking")
    createLabel(featuresContainer, "• Multiple events overlap")
    createLabel(featuresContainer, "• Bisa infinite event")
end

-- ===== MAIN MENU =====
local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(1, 0, 0, 40)
menuFrame.BackgroundTransparency = 1
menuFrame.Parent = mainFrame

local menuLayout = Instance.new("UIListLayout")
menuLayout.FillDirection = Enum.FillDirection.Horizontal
menuLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
menuLayout.Padding = UDim.new(0, 10)
menuLayout.Parent = menuFrame

-- Create menu buttons
local function createMenuButton(name, func)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
    btn.Text = name
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.Parent = menuFrame
    
    btn.MouseButton1Click:Connect(func)
end

createMenuButton("RNG Stack", exploitRNGStacking)
createMenuButton("Auto/Manual", exploitAutoManual)
createMenuButton("Inventory", exploitInventory)
createMenuButton("Trading", exploitTrading)
createMenuButton("Weather", exploitWeatherEvent)

-- Default menu
exploitRNGStacking()

-- ===== DRAG =====
local dragging = false
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        mainFrame.Position = UDim2.new(0, mouse.X - 350, 0, mouse.Y - 250)
    end
end)

mainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

print("🔥 Moe V1.0 - Developer Nightmare Edition")
print("🎯 Target: 5 titik paling ribet untuk developer")